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
  class BuildNeed < Ci::ApplicationRecord
    include BulkInsertSafe

    MAX_JOB_NAME_LENGTH = 255

    before_validation :set_project_id, on: :create

    belongs_to :build,
      class_name: 'Ci::Build',
      foreign_key: :build_id,
      inverse_of: :needs

    validates :build, presence: true
    validates :name, presence: true, length: { maximum: MAX_JOB_NAME_LENGTH }
    validates :optional, inclusion: { in: [true, false] }
    validates :project_id, presence: true, on: :create

    scope :scoped_build, -> {
      where(arel_table[:build_id].eq(Ci::Build.arel_table[:id]))
    }
    scope :artifacts, -> { where(artifacts: true) }

    scope :scoped_build, -> {
      where(arel_table[:build_id].eq(Ci::Build.arel_table[:id]))
    }

    # TODO: This is temporary code to assist the backfilling of records for this epic: https://gitlab.com/groups/gitlab-org/-/epics/12323
    # To be removed in 17.7: https://gitlab.com/gitlab-org/gitlab/-/issues/488163
    #
    def set_project_id
      self.project_id ||= build&.project_id
    end
  end
end

