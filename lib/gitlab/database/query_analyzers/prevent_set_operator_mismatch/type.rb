# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    module QueryAnalyzers
      class PreventSetOperatorMismatch
        # An enumerated set of constants that represent the state of the parse.
        module Type
          STATIC = :static
          DYNAMIC = :dynamic
          INVALID = :invalid
        end
      end
    end
  end
end
