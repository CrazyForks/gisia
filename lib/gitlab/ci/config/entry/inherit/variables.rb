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
        # This class represents a variables inherit entry
        #
        class Inherit
          class Variables < ::Gitlab::Config::Entry::Simplifiable
            strategy :BooleanStrategy, if: ->(config) { [true, false].include?(config) }
            strategy :ArrayStrategy, if: ->(config) { config.is_a?(Array) }

            class BooleanStrategy < ::Gitlab::Config::Entry::Boolean
            end

            class ArrayStrategy < ::Gitlab::Config::Entry::Node
              include ::Gitlab::Config::Entry::Validatable

              validations do
                validates :config, type: Array
                validates :config, array_of_strings: true
              end
            end

            class UnknownStrategy < ::Gitlab::Config::Entry::Node
              def errors
                ["#{location} should be a bool or array of strings"]
              end
            end
          end
        end
      end
    end
  end
end
