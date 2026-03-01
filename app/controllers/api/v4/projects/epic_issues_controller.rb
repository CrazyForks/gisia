# frozen_string_literal: true

module API
  module V4
    module Projects
      class EpicIssuesController < ::API::V4::ProjectBaseController
        include ::Projects::IssueAuthorizable

        before_action :find_epic!
        before_action :authorize_read_issuable!

        def index
          @issues = paginate(@epic.children.where(type: 'Issue').order(created_at: :desc))
        end

        private

        def issuable_resource
          @epic
        end

        def find_epic!
          @epic = @project.namespace.epics.find_by(iid: params[:epic_iid])
          not_found! unless @epic
        end
      end
    end
  end
end
