# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module BlobViewer
  module Simple
    extend ActiveSupport::Concern

    included do
      self.type = :simple
      self.switcher_icon = 'code'
      self.switcher_title = 'source'
    end
  end
end
