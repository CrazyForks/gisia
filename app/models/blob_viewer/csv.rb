# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module BlobViewer
  class CSV < Base
    include Rich
    include ClientSide

    self.binary = false
    self.extensions = %w[csv]
    self.partial_name = 'csv'
    self.switcher_icon = 'table'
  end
end
