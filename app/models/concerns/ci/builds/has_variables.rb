# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module Builds
    module HasVariables
      extend ActiveSupport::Concern
      include Gitlab::Utils::StrongMemoize
      include Gitlab::Routing.url_helpers
      include ProjectsHelper
      extend MethodOverrideGuard

      included do
        has_many :job_variables, class_name: 'Ci::JobVariable', foreign_key: :job_id, inverse_of: :job

        accepts_nested_attributes_for :job_variables
      end

      ##
      # All variables, including persisted environment variables.
      #
      def variables
        strong_memoize(:variables) do
          Gitlab::Ci::Variables::Collection.new
                                           .concat(base_variables)
        end
      end

      def base_variables
        ::Gitlab::Ci::Variables::Collection.new
                                           .concat(persisted_variables)
                                           .concat(job_jwt_variables)
                                           .concat(scoped_variables)
                                           .concat(job_variables)
                                           .concat(persisted_environment_variables)
      end
      strong_memoize_attr :base_variables

      def persisted_variables
        Gitlab::Ci::Variables::Collection.new.tap do |variables|
          break variables unless persisted?

          variables
            .concat(pipeline.persisted_variables)
            .append(key: 'CI_JOB_ID', value: id.to_s)
            .append(key: 'CI_JOB_URL', value: job_url(self))
            .append(key: 'CI_JOB_TOKEN', value: token.to_s, public: false, masked: true)
            .append(key: 'CI_JOB_STARTED_AT', value: started_at&.iso8601)
            .append(key: 'CI_REGISTRY_USER', value: ::Gitlab::Auth::CI_JOB_USER)
            .append(key: 'CI_REGISTRY_PASSWORD', value: token.to_s, public: false, masked: true)
            .append(key: 'CI_REPOSITORY_URL', value: repo_url.to_s, public: false)
            .concat(deploy_token_variables)
        end
      end

      def dependency_variables
        []
      end

      def deploy_token_variables
        Gitlab::Ci::Variables::Collection.new.tap do |variables|
          break variables unless gitlab_deploy_token

          variables.append(key: 'CI_DEPLOY_USER', value: gitlab_deploy_token.username)
          variables.append(key: 'CI_DEPLOY_PASSWORD', value: gitlab_deploy_token.token, public: false, masked: true)
        end
      end

      def gitlab_deploy_token; end

      def job_jwt_variables
        id_tokens_variables
      end

      def id_tokens_variables
        Gitlab::Ci::Variables::Collection.new.tap do |variables|
          break variables unless id_tokens?

          sub_components = project.ci_id_token_sub_claim_components.map(&:to_sym)

          id_tokens.each do |var_name, token_data|
            token = Gitlab::Ci::JwtV2.for_build(self, aud: expanded_id_token_aud(token_data['aud']),
              sub_components: sub_components)

            variables.append(key: var_name, value: token, public: false, masked: true)
          end
        rescue OpenSSL::PKey::RSAError, Gitlab::Ci::Jwt::NoSigningKeyError => e
          Gitlab::ErrorTracking.track_exception(e)
        end
      end

      def persisted_environment_variables
        Gitlab::Ci::Variables::Collection.new.tap do |variables|
          break variables unless persisted? && persisted_environment.present?

          variables.append(key: 'CI_ENVIRONMENT_SLUG', value: environment_slug)

          # Here we're passing unexpanded environment_url for runner to expand,
          # and we need to make sure that CI_ENVIRONMENT_NAME and
          # CI_ENVIRONMENT_SLUG so on are available for the URL be expanded.
          variables.append(key: 'CI_ENVIRONMENT_URL', value: environment_url) if environment_url
        end
      end
    end
  end
end
