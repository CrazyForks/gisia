# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module ActiveRecordRelationAllowCrossJoins
  def allow_cross_joins_across_databases(url:)
    # this method is implemented in:
    # spec/support/database/prevent_cross_joins.rb
    self
  end
end

ActiveRecord::Relation.prepend(ActiveRecordRelationAllowCrossJoins)
