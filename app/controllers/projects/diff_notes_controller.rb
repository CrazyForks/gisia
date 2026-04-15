# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::DiffNotesController < Projects::ApplicationController
  before_action :merge_request
  before_action :authorize_create_note!

  def create
    discussion_id = diff_note_params[:discussion_id].present? ? diff_note_params[:discussion_id].to_i : nil

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
        "comment-form-#{diff_note_params[:line_code]}",
        partial: 'shared/error',
        locals: { errors: @diff_note.errors.full_messages }
      )
    end
  end

  private

  def merge_request
    @merge_request ||= project.merge_requests.find_by!(iid: params[:merge_request_iid])
  end

  def authorize_create_note!
    head :forbidden unless current_user&.can?(:create_note, @merge_request)
  end

  def diff_note_params
    params.require(:diff_note).permit(:note, :line_code, :position, :discussion_id).tap do |whitelisted|
      whitelisted[:type] = 'DiffNote'

      position = parse_position(whitelisted[:position])
      whitelisted[:position] = position
      whitelisted[:original_position] = position
    end
  end

  def parse_position(position_json)
    return nil unless position_json.present?

    pos = Gitlab::Json.parse(position_json).with_indifferent_access
    Gitlab::Diff::Position.new(pos.slice(
      :base_sha, :start_sha, :head_sha,
      :old_path, :new_path, :old_line, :new_line,
      :position_type, :line_range
    ))
  end
end
