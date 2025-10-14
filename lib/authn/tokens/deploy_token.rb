# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Authn
  module Tokens
    class DeployToken
      def self.prefix?(plaintext)
        deploy_token_prefixes = [::DeployToken.prefix_for_deploy_token,
          ::DeployToken::DEPLOY_TOKEN_PREFIX].uniq

        plaintext.start_with?(*deploy_token_prefixes)
      end

      attr_reader :revocable, :source

      def initialize(plaintext, source)
        @revocable = ::DeployToken.find_by_token(plaintext)
        @source = source
      end

      def present_with
        ::API::Entities::DeployToken
      end

      def revoke!(current_user)
        raise ::Authn::AgnosticTokenIdentifier::NotFoundError, 'Not Found' if revocable.blank?

        @current_user = current_user

        service = service_by_type

        service.source = source
        service.execute
      end

      private

      attr_reader :current_user

      def service_by_type
        if revocable.group
          group_revoke_service
        elsif revocable.project
          project_revoke_service
        else
          raise ::Authn::AgnosticTokenIdentifier::UnsupportedTokenError, 'Unsupported deploy token type'
        end
      end

      def project_revoke_service
        ::Projects::DeployTokens::RevokeService.new(
          project: revocable.project,
          current_user: current_user,
          params: { id: revocable.id }
        )
      end

      def group_revoke_service
        ::Groups::DeployTokens::RevokeService.new(
          revocable.group,
          current_user,
          { id: revocable.id }
        )
      end
    end
  end
end
