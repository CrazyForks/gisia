# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module HookData
    class ResourceAccessTokenBuilder < BaseBuilder
      SAFE_HOOK_ATTRIBUTES = %i[
        user_id
        created_at
        id
        name
        expires_at
      ].freeze

      alias_method :resource_access_token, :object

      def build
        resource_access_token
          .attributes
          .with_indifferent_access
          .slice(*SAFE_HOOK_ATTRIBUTES)
      end
    end
  end
end
