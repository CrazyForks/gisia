# frozen_string_literal: true

class Projects::BoardsController < Projects::ApplicationController
  def index
    @board = @project.namespace.board
    @stages = @board.stages.ordered
    @stages_with_issues = @stages.map do |stage|
      {
        stage: stage,
        issues: issues_for_stage(stage)
      }
    end
  end

  private

  def issues_for_stage(stage)
    @project.namespace.issues.with_label_ids(stage.label_ids).includes(:author, :labels).order(created_at: :desc)
  end
end
