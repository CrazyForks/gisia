# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Workhorse
  module UploadPath
    def workhorse_upload_path
      File.join(root, base_dir, 'tmp/uploads')
    end
  end
end
