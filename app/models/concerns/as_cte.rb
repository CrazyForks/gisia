# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# Convert any ActiveRecord::Relation to a Gitlab::SQL::CTE
module AsCte
  extend ActiveSupport::Concern

  class_methods do
    def as_cte(name, **opts)
      Gitlab::SQL::CTE.new(name, all, **opts)
    end
  end
end
