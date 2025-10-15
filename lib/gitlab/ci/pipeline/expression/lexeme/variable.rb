# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Pipeline
      module Expression
        module Lexeme
          class Variable < Lexeme::Value
            PATTERN = /\$(?<name>\w+)/

            def evaluate(variables = {})
              unless variables.is_a?(ActiveSupport::HashWithIndifferentAccess)
                variables = variables.with_indifferent_access
              end

              variables.fetch(@value, nil)
            end

            def inspect
              "$#{@value}"
            end

            def self.build(string)
              new(string.match(PATTERN)[:name])
            end
          end
        end
      end
    end
  end
end
