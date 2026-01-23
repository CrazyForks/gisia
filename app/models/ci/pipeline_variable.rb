# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  class PipelineVariable < Ci::ApplicationRecord
    include Ci::HasVariable
    include Ci::RawVariable

    before_validation :ensure_project_id

    belongs_to :pipeline, inverse_of: :variables

    alias_attribute :secret_value, :value

    validates :key, :pipeline, presence: true
    validates :project_id, presence: true

    def hook_attrs
      { key: key, value: value }
    end

    private

    def ensure_project_id
      self.project_id ||= pipeline&.project_id
    end
  end
end
