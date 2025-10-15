# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module DiffViewer
  class Collapsed < Base
    include Simple
    include Static

    self.partial_name = 'collapsed'
  end
end
