# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    # Module that can be injected into a ActiveRecord::Relation to make it
    # read-only.
    module ReadOnlyRelation
      [:delete, :delete_all, :update, :update_all].each do |method|
        define_method(method) do |*args|
          raise(
            ActiveRecord::ReadOnlyRecord,
            "This relation is marked as read-only"
          )
        end
      end
    end
  end
end
