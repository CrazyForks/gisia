# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  class BuildAccess < UserAccess
    # This bypasses the `can?(:access_git)`-check we normally do in `UserAccess`
    # for CI. That way if a user was able to trigger a pipeline, then the
    # build is allowed to clone the project.
    def can_access_git?
      true
    end
  end
end
