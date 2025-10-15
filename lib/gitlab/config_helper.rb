# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab::ConfigHelper
  def gitlab_config_features
    Gitlab.config.gitlab.default_projects_features
  end

  def gitlab_config
    Gitlab.config.gitlab
  end
end
