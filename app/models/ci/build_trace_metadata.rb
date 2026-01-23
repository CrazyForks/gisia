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
  class BuildTraceMetadata < Ci::ApplicationRecord
    MAX_ATTEMPTS = 5

    before_validation :set_project_id

    belongs_to :build,
      class_name: 'Ci::Build',
      inverse_of: :trace_metadata

    belongs_to :trace_artifact, # rubocop:disable Rails/InverseOf -- No clear relation to be used
      class_name: 'Ci::JobArtifact'

    validates :build, presence: true
    validates :archival_attempts, presence: true

    def self.find_or_upsert_for!(build_id, project_id)
      record = find_by(build_id: build_id)
      return record if record

      upsert({ build_id: build_id, project_id: project_id },
        unique_by: %w[build_id])
      find_by!(build_id: build_id)
    end

    # The job is retried around 5 times during the 7 days retention period for
    # trace chunks as defined in `Ci::BuildTraceChunks::RedisBase::CHUNK_REDIS_TTL`
    def can_attempt_archival_now?
      return false unless archival_attempts_available?
      return true unless last_archival_attempt_at

      (last_archival_attempt_at + backoff).past?
    end

    def archival_attempts_available?
      archival_attempts <= MAX_ATTEMPTS
    end

    def increment_archival_attempts!
      increment!(:archival_attempts, touch: :last_archival_attempt_at)
    end

    def track_archival!(trace_artifact_id, checksum)
      update!(trace_artifact_id: trace_artifact_id, checksum: checksum, archived_at: Time.current)
    end

    def archival_attempts_message
      if archival_attempts_available?
        'The job can not be archived right now.'
      else
        'The job is out of archival attempts.'
      end
    end

    def remote_checksum_valid?
      checksum.present? &&
        checksum == remote_checksum
    end

    def successfully_archived?
      return false unless archived_at

      remote_checksum.nil? || remote_checksum_valid?
    end

    private

    def backoff
      ::Gitlab::Ci::Trace::Backoff.new(archival_attempts).value_with_jitter
    end

    def set_project_id
      self.project_id ||= build&.project_id
    end
  end
end
