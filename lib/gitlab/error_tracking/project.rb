# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# This should be in the ErrorTracking namespace. For more details, see:
# https://gitlab.com/gitlab-org/gitlab/-/issues/323342
module Gitlab
  module ErrorTracking
    class Project
      include ActiveModel::Model

      ACCESSORS = [
        :id, :name, :status, :slug, :organization_name,
        :organization_id, :organization_slug
      ].freeze

      attr_accessor(*ACCESSORS)
    end
  end
end
