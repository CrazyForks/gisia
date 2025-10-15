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
          class ParenthesisClose < Lexeme::Operator
            PATTERN = /\)/

            def self.type
              :parenthesis_close
            end

            def self.precedence
              900
            end
          end
        end
      end
    end
  end
end
