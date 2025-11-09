# frozen_string_literal: true

class Projects::StagesController < Projects::ApplicationController
  include StageIssuesFilterable

  before_action :authorize_maintainer
  before_action :set_board
  before_action :set_stage, except: [:create]

  def create
    @stage = @board.stages.build(title: params[:title] || 'List')
    @stage.rank = closed_stage.rank if closed_stage

    if @stage.save
      @issues = issues_for_stage
      @can_edit_board = can_edit_board?
      @show_edit_form = true
    else
      flash.now[:alert] = @stage.errors.full_messages.join(', ')
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit_stage
    @labels = @project.namespace.labels

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_stage
    update_params = {}
    update_params[:title] = params[:title] if params[:title].present?
    update_params[:rank] = params[:rank] if params[:rank].present?
    @stage.update(update_params)
    @issues = issues_for_stage
    @can_edit_board = can_edit_board?

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_labels
    stage_params = params[:stage] || {}
    label_ids = stage_params[:label_ids]&.split(',')&.reject(&:blank?) || []
    update_params = { label_ids: label_ids }.compact
    @stage.update(update_params)
    @issues = issues_for_stage
    @can_edit_board = can_edit_board?

    respond_to do |format|
      format.turbo_stream
    end
  end

  def search_stage_labels
    @labels = @project.namespace.labels.search_by_title(params[:q]).limit(10)
    @selected_ids = @stage.label_ids.map(&:to_s)

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def authorize_maintainer
    access_level = @project.team.max_member_access(current_user.id)
    redirect_to root_path unless access_level >= Gitlab::Access::MAINTAINER
  end

  def can_edit_board?
    access_level = @project.team.max_member_access(current_user.id)
    access_level >= Gitlab::Access::MAINTAINER
  end

  def set_board
    @board = @project.namespace.board
  end

  def set_stage
    @stage = @board.stages.find(params[:id])
  end

  def closed_stage
    @closed_stage ||= @board.stages.find_by(kind: :closed)
  end
end
