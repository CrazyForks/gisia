# frozen_string_literal: true

class Projects::BoardsController < Projects::ApplicationController
  include StageIssuesFilterable

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

  def can_edit_board?
    access_level = @project.team.max_member_access(current_user.id)
    access_level >= Gitlab::Access::MAINTAINER
  end
end

