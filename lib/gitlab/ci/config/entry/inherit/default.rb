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
        ##
        # This class represents a default inherit entry
        #
        class Inherit
          class Default < ::Gitlab::Config::Entry::Simplifiable
            strategy :BooleanStrategy, if: ->(config) { [true, false].include?(config) }
            strategy :ArrayStrategy, if: ->(config) { config.is_a?(Array) }

            class BooleanStrategy < ::Gitlab::Config::Entry::Boolean
              def inherit?(_key)
                value
              end
            end

            class ArrayStrategy < ::Gitlab::Config::Entry::Node
              include ::Gitlab::Config::Entry::Validatable

              ALLOWED_VALUES = ::Gitlab::Ci::Config::Entry::Default::ALLOWED_KEYS.map(&:to_s).freeze

              validations do
                validates :config, type: Array
                validates :config, array_of_strings: true
                validates :config, allowed_array_values: { in: ALLOWED_VALUES }
              end

              def inherit?(key)
                value.include?(key.to_s)
              end
            end

            class UnknownStrategy < ::Gitlab::Config::Entry::Node
              def errors
                ["#{location} should be a bool or array of strings"]
              end

              def inherit?(key)
                false
              end
            end
          end
        end
      end
    end
  end
end
