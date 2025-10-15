# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module DiffViewer
  module ClientSide
    extend ActiveSupport::Concern

    included do
      self.collapse_limit = 1.megabyte
      self.size_limit = 10.megabytes
    end
  end
end
