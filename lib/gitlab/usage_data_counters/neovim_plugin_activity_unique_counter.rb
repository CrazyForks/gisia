# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module UsageDataCounters
    module NeovimPluginActivityUniqueCounter
      NEOVIM_PLUGIN_API_REQUEST_ACTION = 'i_editor_extensions_user_neovim_plugin_api_request'
      NEOVIM_PLUGIN_USER_AGENT_REGEX = /gitlab.vim/

      class << self
        def track_api_request_when_trackable(user_agent:, user:)
          user_agent&.match?(NEOVIM_PLUGIN_USER_AGENT_REGEX) &&
            track_unique_action_by_user(NEOVIM_PLUGIN_API_REQUEST_ACTION, user)
        end

        private

        def track_unique_action_by_user(action, user)
          return unless user

          track_unique_action(action, user.id)
        end

        def track_unique_action(action, value)
          Gitlab::UsageDataCounters::HLLRedisCounter.track_usage_event(action, value)
        end
      end
    end
  end
end
