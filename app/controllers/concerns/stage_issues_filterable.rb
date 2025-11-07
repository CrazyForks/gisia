module StageIssuesFilterable
  extend ActiveSupport::Concern

  private

  def issues_for_stage(stage = nil)
    stage ||= @stage
    query = @project.namespace.issues.with_label_ids(stage.label_ids).includes(:author, :labels).order(created_at: :desc)
    if stage.title == 'Closed'
      query.closed
    else
      query.open
    end
  end
end
