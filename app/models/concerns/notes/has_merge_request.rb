# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Notes
  module HasMergeRequest
    extend ActiveSupport::Concern

    included do
      belongs_to :noteable, class_name: 'MergeRequest', foreign_key: :noteable_id

      before_validation :set_noteable_type

      scope :with_merge_request, ->(merge_request) { where(noteable: merge_request) }

      validates :noteable_type, inclusion: { in: ['MergeRequest'] }
    end

    def merge_request
      noteable
    end

    def project
      merge_request&.project
    end

    def for_merge_request?
      noteable_type == 'MergeRequest'
    end

    private

    def set_noteable_type
      self.noteable_type = 'MergeRequest'
    end
  end
end