# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::NotesController < Projects::ApplicationController
  before_action :find_noteable, only: %i[index create]
  before_action :find_note, only: %i[show edit update destroy resolve unresolve replies expand collapse]
  before_action :authorize_read_note!
  before_action :authorize_create_note!, only: [:create]
  before_action :authorize_admin_note!, only: [:update, :destroy]

  def index
    @notes = notes_finder.execute
                         .inc_relations_for_view
                         .fresh

    respond_to do |format|
      format.json do
        render json: {
          notes: @notes.map { |note| note_json(note) },
          last_fetched_at: Time.current.to_i
        }
      end
    end
  end

  def show; end

  def edit; end

  def replies
    @replies = @note.replies.inc_relations_for_view.fresh
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    partition_model = Note.partition_model_for(@noteable.class.name)

    # Handle discussion_id: nil for root notes, parent note ID for replies
    discussion_id = note_params[:discussion_id].present? ? note_params[:discussion_id].to_i : nil

    @note = partition_model.new(note_params.merge(
      noteable: @noteable,
      noteable_type: @noteable.class.name,
      noteable_id: @noteable.id,
      author: current_user,
      namespace: @project.namespace,
      discussion_id: discussion_id
    ))

    @quick_action_updates = execute_quick_actions(@note)

    respond_to do |format|
      if @note.note.blank? && @quick_action_updates.present?
        apply_quick_action_updates
        format.turbo_stream { redirect_to noteable_path }
      elsif @note.save
        apply_quick_action_updates
        # If this is a reply, also set the parent note for the view
        @parent_note = Note.find(discussion_id) if discussion_id.present?
        format.turbo_stream { @quick_action_updates.present? ? redirect_to(noteable_path) : render(:create) }
      else
        format.turbo_stream { render :error }
      end
    end
  end

  def update
    @note.assign_attributes(note_params.slice(:note, :internal))
    @note.updated_by = current_user
    @note.last_edited_at = Time.current
    @note.save

    respond_to do |format|
      format.json do
        if @note.valid?
          render json: note_json(@note)
        else
          render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
        end
      end
      format.turbo_stream do
        if @note.valid?
          render :update
        else
          render :error
        end
      end
    end
  end

  def destroy
    @note.destroy

    respond_to do |format|
      format.json do
        if @note.destroyed?
          head :ok
        else
          render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
        end
      end
      format.turbo_stream do
        if @note.destroyed?
          render :destroy
        else
          render :error
        end
      end
    end
  end

  def expand
    respond_to { |f| f.turbo_stream }
  end

  def collapse
    respond_to { |f| f.turbo_stream }
  end

  def resolve
    return render_404 unless @note.resolvable?

    @note.resolve!(current_user)

    respond_to do |format|
      format.json do
        render json: note_json(@note)
      end
      format.turbo_stream
    end
  end

  def unresolve
    return render_404 unless @note.resolvable?

    @note.unresolve!

    respond_to do |format|
      format.json do
        render json: note_json(@note)
      end
      format.turbo_stream
    end
  end

  private

  def find_noteable
    target_id = params[:target_id]
    @noteable ||= case note_params[:noteable_type]
                  when 'MergeRequest'
                    @project.merge_requests.find_by(id: target_id)
                  else
                    @project.work_items.find_by(id: target_id)
                  end
  end

  def find_note
    @note ||= Note.find(params[:id])
  end

  def notes_finder
    NotesFinder.new(
      current_user,
      namespace: @project.namespace,
      noteable: @noteable,
      notes_filter: params.permit(:notes_filter)[:notes_filter] || NotesFinder::NOTES_FILTERS[:all_notes]
    )
  end

  def note_params
    params.require(:note).permit(:note, :noteable_type, :noteable_id, :discussion_id, :internal)
  end

  def noteable_path
    namespace_path = @project.namespace.parent.full_path

    case @noteable
    when MergeRequest
      namespace_project_merge_request_path(namespace_path, @project.path, @noteable)
    when Epic
      namespace_project_epic_path(namespace_path, @project.path, @noteable)
    else
      namespace_project_issue_path(namespace_path, @project.path, @noteable)
    end
  end

  def quick_actions_service
    @quick_actions_service ||= Notes::QuickActionsService.new(@project, current_user)
  end

  def execute_quick_actions(note)
    return {} unless quick_actions_service.supported?(note)

    content, updates, message, _command_names = quick_actions_service.execute(note)
    note.note = content
    @quick_action_message = message

    updates
  end

  def apply_quick_action_updates
    return if @quick_action_updates.blank?

    # apply_updates returns nil when it has nothing to apply
    response = quick_actions_service.apply_updates(@quick_action_updates, @note)
    return if response.nil?

    if response.success?
      flash[:notice] = @quick_action_message if @quick_action_message.present?
    else
      flash[:alert] = response.message.to_sentence
    end
  end

  def authorize_read_note!
    head :forbidden unless current_user&.can?(:read_note, @project)
  end

  def authorize_create_note!
    head :forbidden unless current_user&.can?(:create_note, @noteable)
  end

  def authorize_admin_note!
    head :forbidden unless current_user&.can?(:admin_note, @note)
  end

  def note_json(note)
    {
      id: note.id,
      type: note.type,
      author: {
        id: note.author.id,
        name: note.author.name,
        username: note.author.username,
        avatar_url: asset_path('default_avatar.png')
      },
      created_at: note.created_at.iso8601,
      updated_at: note.updated_at.iso8601,
      system: note.system?,
      internal: note.internal?,
      note: note.note,
      note_html: note.note, # Simple fallback without markdown rendering
      resolved: note.resolved?,
      resolvable: note.resolvable?,
      resolved_by: note.resolved_by&.name,
      resolved_at: note.resolved_at&.iso8601,
      edited: note.edited?,
      last_edited_at: note.last_edited_at&.iso8601,
      last_edited_by: note.last_edited_by&.name,
      discussion_id: note.discussion_id
    }
  end
end
