# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  class PipelineMessage < Ci::ApplicationRecord
    MAX_CONTENT_LENGTH = 10_000

    belongs_to :pipeline

    validates :project_id, presence: true
    validates :content, presence: true

    before_save :truncate_long_content

    enum :severity, { error: 0, warning: 1 }

    private

    def truncate_long_content
      return if content.length <= MAX_CONTENT_LENGTH

      self.content = content.truncate(MAX_CONTENT_LENGTH)
    end
  end
end

