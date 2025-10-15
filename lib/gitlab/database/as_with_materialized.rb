# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    # This class is a special Arel node which allows optionally define the `MATERIALIZED` keyword for CTE and Recursive CTE queries.
    class AsWithMaterialized < Arel::Nodes::As
      MATERIALIZED = 'MATERIALIZED '

      def initialize(left, right, materialized: true)
        if materialized
          right.prepend(MATERIALIZED)
        end

        super(left, right)
      end
    end
  end
end
