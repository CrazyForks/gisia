# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module Interpolation
        module Functions
          class Truncate < Base
            def self.function_expression_pattern
              /^#{name}\(\s*(?<offset>\d+)\s*,\s*(?<length>\d+)\s*\)?$/
            end

            def self.name
              'truncate'
            end

            def execute(input_value)
              if input_value.is_a?(String)
                input_value[offset, length].to_s
              else
                error('invalid input type: truncate can only be used with string inputs')
                nil
              end
            end

            private

            def offset
              function_args[:offset].to_i
            end

            def length
              function_args[:length].to_i
            end
          end
        end
      end
    end
  end
end
