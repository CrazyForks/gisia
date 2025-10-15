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
          class ParenthesisOpen < Lexeme::Operator
            PATTERN = /\(/

            def self.type
              :parenthesis_open
            end

            def self.precedence
              # Needs to be higher than `ParenthesisClose` and all other Lexemes
              901
            end
          end
        end
      end
    end
  end
end
