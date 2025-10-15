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
  module HasNoteDiffFile
    extend ActiveSupport::Concern
    include Gitlab::Utils::StrongMemoize

    included do
      has_one :note_diff_file, inverse_of: :diff_note, foreign_key: :diff_note_id

      validate :validate_diff_file_and_line, on: :create, if: :requires_diff_file_validation_during_import?
    end

    # Returns the diff file from `original_position`
    def diff_file(create_missing_diff_file: true)
      strong_memoize(:diff_file) do
        next if for_design?

        enqueue_diff_file_creation_job if create_missing_diff_file && should_create_diff_file?

        fetch_diff_file
      end
    end

    def diff_line
      @diff_line ||= diff_file&.line_for_position(self.original_position)
    end

    private

    def created_at_diff?(diff_refs)
      return false unless supported?
      return true if for_commit?

      self.original_position.diff_refs == diff_refs
    end

    def requires_diff_file_validation_during_import?
      importing? && should_create_diff_file?
    end

    def should_create_diff_file?
      on_text? && note_diff_file.nil? && start_of_discussion?
    end

    def validate_diff_file_and_line
      diff_file = diff_file(create_missing_diff_file: false)

      unless diff_file
        errors.add(:base, :missing_diff_file, message: DIFF_FILE_NOT_FOUND_MESSAGE)
        return
      end

      diff_line = diff_file.line_for_position(self.original_position)

      return if diff_line

      errors.add(:base, :missing_diff_line,
        message: format(DIFF_LINE_NOT_FOUND_MESSAGE, file_path: diff_file.file_path, old_line: original_position.old_line, new_line: original_position.new_line))
    end

    def fetch_diff_file
      return note_diff_file.raw_diff_file if note_diff_file && !note_diff_file.raw_diff_file.has_renderable?

      if noteable && created_at_diff?(noteable.diff_refs)
        # We're able to use the already persisted diffs (Postgres) if we're
        # presenting a "current version" of the MR discussion diff.
        # So no need to make an extra Gitaly diff request for it.
        # As an extra benefit, the returned `diff_file` already
        # has `highlighted_diff_lines` data set from Redis on
        # `Diff::FileCollection::MergeRequestDiff`.
        file = original_position.find_diff_file_from(noteable)
        # if line is not found in persisted diffs, fallback and retrieve file from repository using gitaly
        # This is required because of https://gitlab.com/gitlab-org/gitlab/issues/42676
        file = nil if file&.line_for_position(original_position).nil? && importing?
      end

      file ||= original_position.diff_file(repository)
      file&.unfold_diff_lines(position)

      file
    end

    def should_create_diff_file?
      on_text? && note_diff_file.nil? && start_of_discussion?
    end

    def enqueue_diff_file_creation_job
      # Avoid enqueuing multiple file creation jobs at once for a note (i.e.
      # parallel calls to `DiffNote#diff_file`).
      lease = Gitlab::ExclusiveLease.new("note_diff_file_creation:#{id}", timeout: 1.hour.to_i)
      nil unless lease.try_obtain

      # CreateNoteDiffFileWorker.perform_async(id)
    end
  end
end
