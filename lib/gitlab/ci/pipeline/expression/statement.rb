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
        class Statement
          StatementError = Class.new(Expression::ExpressionError)

          def initialize(statement, variables = nil)
            @lexer = Expression::Lexer.new(statement)
            @variables = variables || {}
          end

          def parse_tree
            raise StatementError if @lexer.lexemes.empty?

            Expression::Parser.new(@lexer.tokens).tree
          end

          def evaluate
            parse_tree.evaluate(@variables)
          end

          def truthful?
            evaluate.present?
          rescue Expression::ExpressionError
            false
          end

          def valid?
            evaluate
            parse_tree.is_a?(Lexeme::Base)
          rescue Expression::ExpressionError
            false
          end
        end
      end
    end
  end
end
