# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ssh
  class Accessor
    attr_reader :params, :redirected_path

    def initialize(params)
      @params = params
    end

    def check!
      # Stores some Git-specific env thread-safely
      #
      # Snapshot repositories have different relative path than the main repository. For access
      # checks that need quarantined objects the relative path in also sent with Gitaly RPCs
      # calls as a header.
      Gitlab::Git::HookEnv.set(gl_repository, params[:relative_path], parse_env) if container
      @check_result = check_result
    end

    def payload
      {
        status: true,
        gl_repository: gl_repository,
        gl_project_path: gl_repository_path,
        gl_project_id: project&.id,
        gl_root_namespace_id: project&.root_namespace&.id,
        gl_id: Gitlab::GlId.gl_id(actor.user),
        gl_username: actor.username,
        git_config_options: ['uploadpack.allowFilter=true',
                             'uploadpack.allowAnySHA1InWant=true'],
        gitaly: gitaly_payload(params[:action]),
        gl_console_messages: @check_result.console_messages,
        need_audit: false
      }.merge!(actor.key_details)
    end

    def actor
      @actor ||= ::API::Support::GitAccessActor.from_params(params)
    end

    def post_receive
      PostReceive.new.execute(
        params[:gl_repository], params[:identifier],
        params[:changes], Gitlab::PushOptions.new([]).as_json
      )

      {
        messages: [
          { message: 'received :D',
            type: 'basic' }
        ],
        reference_counter_decreased: Gitlab::ReferenceCounter.new(params[:gl_repository]).decrease
      }
    end

    private

    def check_result
      access_checker = access_checker_for(actor, params[:protocol])
      access_checker.check(params[:action], params[:changes]).tap do |result|
        break result if @project || !repo_type.project?

        @project = @container = access_checker.container
      end
    end

    def parse_env
      return {} if params[:env].blank?

      Gitlab::Json.parse(params[:env])
    rescue JSON::ParserError
      {}
    end

    def gl_repository
      repo_type.identifier_for_container(container)
    end

    def gl_repository_path
      repository.full_path
    end

    def repository
      @repository ||= repo_type.repository_for(container)
    end

    def repo_type
      parse_repo_path unless defined?(@repo_type)
      @repo_type
    end

    def project
      parse_repo_path unless defined?(@project)
      @project
    end

    def container
      parse_repo_path unless defined?(@container)
      @container
    end

    def access_checker_for(actor, protocol)
      access_checker_klass.new(actor.key_or_user, container, protocol,
                               authentication_abilities: ssh_authentication_abilities,
                               repository_path: repository_path,
                               redirected_path: redirected_path,
                               push_options: params[:push_options])
    end

    def access_checker_klass
      repo_type.access_checker_class
    end

    def ssh_authentication_abilities
      %i[
        read_project
        download_code
        push_code
      ]
    end

    def parse_repo_path
      @container, @project, @repo_type, @redirected_path =
        if params[:gl_repository]
          Gitlab::GlRepository.parse(params[:gl_repository])
        elsif params[:project]
          Gitlab::RepoPath.parse(params[:project])
        end
    end

    def repository_path
      if container
        "#{container.full_path}.git"
      elsif params[:project]
        # When the project doesn't exist, we still need to pass on the path
        # to support auto-creation in `GitAccessProject`.
        #
        # For consistency with the Git HTTP controllers, we normalize the path
        # to remove a leading slash and ensure a trailing `.git`.
        #
        # NOTE: For GitLab Shell, `params[:project]` is the full repository path
        # from the SSH command, with an optional trailing `.git`.
        "#{params[:project].delete_prefix('/').delete_suffix('.git')}.git"
      end
    end

    def gitaly_payload(action)
      return unless %w[git-receive-pack git-upload-pack git-upload-archive].include?(action)

      {
        repository: repository.gitaly_repository.to_h,
        address: Gitlab::GitalyClient.address(repository.shard),
        token: Gitlab::GitalyClient.token(repository.shard),
        features: Feature::Gitaly.server_feature_flags(
          user: ::Feature::Gitaly.user_actor(actor.user),
          repository: repository,
          project: ::Feature::Gitaly.project_actor(repository.container),
          group: ::Feature::Gitaly.group_actor(repository.container)
        )
      }
    end
  end
end
