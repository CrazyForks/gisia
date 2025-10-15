# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module ObjectStorable
  extend ActiveSupport::Concern

  included do
    scope :with_files_stored_locally, -> { where(klass::STORE_COLUMN => ObjectStorage::Store::LOCAL) }
    scope :with_files_stored_remotely, -> { where(klass::STORE_COLUMN => ObjectStorage::Store::REMOTE) }
  end
end
