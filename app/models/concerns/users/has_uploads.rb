# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Users
  module HasUploads
    extend ActiveSupport::Concern
    include WithUploads
    include Avatarable

    included do
      has_many :uploaded_uploads, class_name: 'Upload', foreign_key: :uploaded_by_user_id
    end

    def uploads_sharding_key
      {}
    end
  end
end
