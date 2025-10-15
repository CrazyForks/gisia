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
          class Operator < Lexeme::Base
            OperatorError = Class.new(Expression::ExpressionError)

            def self.type
              raise NotImplementedError
            end

            def self.precedence
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
