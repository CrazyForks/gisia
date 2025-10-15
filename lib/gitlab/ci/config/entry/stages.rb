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
        # Entry that represents a configuration for pipeline stages.
        #
        class Stages < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Validatable

          MAX_NESTING_LEVEL = 10

          validations do
            validates :config, nested_array_of_strings: { max_level: MAX_NESTING_LEVEL }
          end

          def self.default
            Config::Stages.wrap_with_edge_stages %w[build test deploy]
          end

          def value
            @config.flatten
          end
        end
      end
    end
  end
end
