# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module CustomUrlHelpers
  def project_commit_path(project, commit)
    "/#{project.full_path}/-/commit/#{commit.id}"
  end
end

Rails.application.routes.url_helpers.singleton_class.prepend(CustomUrlHelpers)
