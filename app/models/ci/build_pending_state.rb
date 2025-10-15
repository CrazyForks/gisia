# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Ci::BuildPendingState < Ci::ApplicationRecord
  attr_accessor :partition_id

  before_validation :set_project_id, on: :create
  belongs_to :build,
    class_name: 'Ci::Build',
    foreign_key: :build_id,
    inverse_of: :pending_state

  enum :state, Ci::Stage.statuses
  enum :failure_reason, CommitStatus.failure_reasons

  validates :build, presence: true
  validates :project_id, presence: true, on: :create

  def crc32
    trace_checksum.try do |checksum|
      checksum.to_s.split('crc32:').last.to_i(16)
    end
  end

  def set_project_id
    self.project_id ||= build&.project_id
  end
end
