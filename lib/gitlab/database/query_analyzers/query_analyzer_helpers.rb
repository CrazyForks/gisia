# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    module QueryAnalyzers
      # Methods that are commonly used between analyzers
      class QueryAnalyzerHelpers
        class << self
          def dml_from_create_view?(parsed)
            parsed.pg.tree.stmts.select { |stmts| stmts.stmt.node == :view_stmt }.any?
          end
        end
      end
    end
  end
end
