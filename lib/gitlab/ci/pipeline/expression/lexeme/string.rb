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
          class String < Lexeme::Value
            PATTERN = /("(?<string>.*?)")|('(?<string>.*?)')/

            def evaluate(variables = {})
              @value.to_s
            end

            def inspect
              @value.inspect
            end

            def self.build(string)
              new(string.match(PATTERN)[:string])
            end
          end
        end
      end
    end
  end
end
