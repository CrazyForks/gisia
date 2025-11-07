# frozen_string_literal: true

class Projects::BoardsController < Projects::ApplicationController
  def index
    @board = @project.namespace.board
    @stages = @board.stages.ordered
    @can_edit_board = can_edit_board?
    @stages_with_issues = @stages.map do |stage|
      {
        stage: stage,
        issues: issues_for_stage(stage)
      }
    end
  end

  private

  def issues_for_stage(stage)
    query = @project.namespace.issues.with_label_ids(stage.label_ids).includes(:author, :labels).order(created_at: :desc)
    if stage.title == 'Closed'
      query.closed
    else
      query.open
    end
  end

  def can_edit_board?
    access_level = @project.team.max_member_access(current_user.id)
    access_level >= Gitlab::Access::MAINTAINER
  end
end

