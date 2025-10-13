# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================


scope(path: '*repository_path', format: false) do
  constraints(repository_path: Gitlab::PathRegex.repository_git_route_regex) do
    scope(module: :repositories) do
      # Git HTTP API
      scope(controller: :git_http) do
        get '/info/refs', action: :info_refs
        post '/git-upload-pack', action: :git_upload_pack
        post '/git-receive-pack', action: :git_receive_pack

        # GitLab-Shell Git over SSH requests
        post '/ssh-upload-pack', action: :ssh_upload_pack
        post '/ssh-receive-pack', action: :ssh_receive_pack
      end
    end
  end


  # Redirect /group/project/info/refs to /group/project.git/info/refs
  # This allows cloning a repository without the trailing `.git`
  constraints(repository_path: Gitlab::PathRegex.repository_route_regex) do
    ref_redirect = redirect do |params, request|
      path = "#{params[:repository_path]}.git/info/refs"
      path += "?#{request.query_string}" unless request.query_string.blank?
      path
    end

    get '/info/refs', constraints: ::Constraints::RepositoryRedirectUrlConstrainer.new, to: ref_redirect
  end
end
