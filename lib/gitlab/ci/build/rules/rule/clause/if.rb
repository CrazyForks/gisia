# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      class Rules::Rule::Clause::If < Rules::Rule::Clause
        def initialize(expression)
          @expression = expression
        end

        def satisfied_by?(_pipeline, context)
          ::Gitlab::Ci::Pipeline::Expression::Statement.new(
            @expression, context.variables_hash).truthful?
        end
      end
    end
  end
end
