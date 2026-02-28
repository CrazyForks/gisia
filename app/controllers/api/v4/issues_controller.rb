# frozen_string_literal: true

module API
  module V4
    class IssuesController < ::API::V4::UserBaseController
      include API::V4::IssueFilterable

      def index
        issues = Issue
          .where(
            'work_items.author_id = ? OR work_items.id IN (?)',
            current_user.id,
            Issue.joins(:assignees).where(users: { id: current_user.id }).select('work_items.id')
          )
        issues = apply_filters(issues)
        @issues = paginate(issues.order(created_at: :desc))
      end
    end
  end
end
