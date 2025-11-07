# frozen_string_literal: true

class Projects::StagesController < Projects::ApplicationController
  before_action :authorize_maintainer
  before_action :set_board
  before_action :set_stage

  def edit_stage
    @labels = @project.namespace.labels

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_stage
    label_ids = params[:stage][:label_ids]&.split(',')&.reject(&:blank?) || []
    @stage.update(label_ids: label_ids)

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

  def set_board
    @board = @project.namespace.board
  end

  def set_stage
    @stage = @board.stages.find(params[:id])
  end
end
