# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module BlobViewer
  module ClientSide
    extend ActiveSupport::Concern

    included do
      self.load_async = false
      self.collapse_limit = 10.megabytes
      self.size_limit = 50.megabytes
    end
  end
end
