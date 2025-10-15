# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module UpdatedAtFilterable
  extend ActiveSupport::Concern

  included do
    scope :updated_before, ->(date) { where(scoped_table[:updated_at].lteq(date)) }
    scope :updated_after, ->(date) { where(scoped_table[:updated_at].gteq(date)) }

    def self.scoped_table
      arel_table.alias(table_name)
    end
  end
end
