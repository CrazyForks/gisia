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
        # Entry that represents CI/CD variables.
        class Variables < ::Gitlab::Config::Entry::ComposableHash
          include ::Gitlab::Config::Entry::Validatable

          validations do
            validates :config, type: Hash
          end

          def self.default(**)
            {}
          end

          def value
            @entries.to_h do |key, entry|
              [key.to_s, entry.value]
            end
          end

          def value_with_data
            @entries.to_h do |key, entry|
              [key.to_s, entry.value_with_data]
            end
          end

          def value_with_prefill_data
            @entries.to_h do |key, entry|
              [key.to_s, entry.value_with_prefill_data]
            end
          end

          private

          def composable_class(_name, _config)
            Entry::Variable
          end

          def composable_metadata
            { allowed_value_data: opt(:allowed_value_data) }
          end
        end
      end
    end
  end
end
