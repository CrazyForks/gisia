# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::DiffNotesController < Projects::ApplicationController
  before_action :merge_request

  def create
    # Handle discussion_id: nil for root notes, parent note ID for replies
    discussion_id = params[:diff_note][:discussion_id].present? ? params[:diff_note][:discussion_id].to_i : nil

    @diff_note = DiffNote.new(diff_note_params.merge(
      noteable: merge_request,
      author: current_user,
      namespace: project.namespace,
      discussion_id: discussion_id
    ))

    if @diff_note.save
      @parent_note = Note.find(discussion_id) if discussion_id.present?
    else
      render turbo_stream: turbo_stream.replace(
        "comment-form-#{params[:diff_note][:line_code]}",
        partial: 'shared/error',
        locals: { errors: @diff_note.errors.full_messages }
      )
    end
  end

  private

  def merge_request
    @merge_request ||= project.merge_requests.find(params[:merge_request_id])
  end

  def diff_note_params
    params.require(:diff_note).permit(:note, :line_code, :position, :discussion_id).tap do |whitelisted|
      whitelisted[:type] = 'DiffNote'

      # Always create position from line_code (ignore any JSON position data)
      position = create_position_from_line_code(whitelisted[:line_code])

      whitelisted[:position] = position
      whitelisted[:original_position] = position
    end
  end


  def create_position_from_line_code(line_code)
    return nil unless line_code.present?

    # Parse line code format: file_hash_old_line_new_line
    parts = line_code.split('_')
    return nil if parts.length < 3

    file_hash = parts[0]
    old_line = parts[1].present? && parts[1] != '' ? parts[1].to_i : nil
    new_line = parts[2].present? && parts[2] != '' ? parts[2].to_i : nil

    # Find the diff file to get the path
    diff_files = merge_request.diffs.diff_files
    diff_file = diff_files.find { |file| Digest::SHA1.hexdigest(file.file_path) == file_hash }

    return nil unless diff_file

    position_attrs = {
      old_path: diff_file.old_path,
      new_path: diff_file.new_path,
      old_line: old_line,
      new_line: new_line,
      base_sha: merge_request.diff_base_sha,
      start_sha: merge_request.diff_start_sha,
      head_sha: merge_request.diff_head_sha,
      position_type: 'text'
    }


    Gitlab::Diff::Position.new(position_attrs)
  end
end
