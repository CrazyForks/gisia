# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      module Policy
        class Variables < Policy::Specification
          def initialize(expressions)
            @expressions = Array(expressions)
          end

          def satisfied_by?(pipeline, context)
            variables = context.variables_hash

            statements = @expressions.map do |statement|
              ::Gitlab::Ci::Pipeline::Expression::Statement
                .new(statement, variables)
            end

            statements.any?(&:truthful?)
          end
        end
      end
    end
  end
end
