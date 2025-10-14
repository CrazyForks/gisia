# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Authn
  module Tokens
    class FeedToken
      def self.prefix?(plaintext)
        feed_token_prefixes = [::User.prefix_for_feed_token,
          ::User::FEED_TOKEN_PREFIX].uniq

        plaintext.start_with?(*feed_token_prefixes)
      end

      attr_reader :revocable, :source

      def initialize(plaintext, source)
        @revocable = User.find_by_feed_token(plaintext)
        @source = source
      end

      def present_with
        ::API::Entities::User
      end

      def revoke!(current_user)
        raise ::Authn::AgnosticTokenIdentifier::NotFoundError, 'Not Found' if revocable.blank?

        Users::ResetFeedTokenService.new(
          current_user,
          user: revocable,
          source: source
        ).execute
      end
    end
  end
end
