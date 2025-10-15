# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module BlobViewer
  class Image < Base
    include Rich
    include ClientSide

    self.partial_name = 'image'
    self.extensions = UploaderHelper::SAFE_IMAGE_EXT
    self.binary = true
    self.switcher_icon = 'doc-image'
    self.switcher_title = 'image'
  end
end
