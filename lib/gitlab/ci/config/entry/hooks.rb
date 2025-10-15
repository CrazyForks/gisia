# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module Entry
        class Hooks < ::Gitlab::Config::Entry::Node
          # `Configurable` alreadys adds `Validatable`
          include ::Gitlab::Config::Entry::Configurable

          # NOTE: If a new hook is added, inheriting should be changed because a `job:hooks` overrides all
          #       `default:hooks` now. We should implement merging; each hook must be overridden individually.
          ALLOWED_HOOKS = %i[pre_get_sources_script].freeze

          validations do
            validates :config, type: Hash, allowed_keys: ALLOWED_HOOKS
          end

          entry :pre_get_sources_script, Entry::Commands,
            description: 'Commands that will be executed on Runner before cloning/fetching the Git repository.'
        end
      end
    end
  end
end
