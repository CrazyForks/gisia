# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module ObjectStorage
  module S3
    def self.signed_head_url(file)
      fog_storage = ::Fog::Storage.new(file.fog_credentials)
      fog_dir = fog_storage.directories.new(key: file.fog_directory)
      fog_file = fog_dir.files.new(key: file.path)
      expire_at = ::Fog::Time.now + file.fog_authenticated_url_expiration

      fog_file.collection.head_url(fog_file.key, expire_at)
    end
  end
end
