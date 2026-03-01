# frozen_string_literal: true

module API
  module V4
    module Projects
      class EpicIssuesController < ::API::V4::ProjectBaseController
        before_action :find_epic!

        def index
          @issues = paginate(@epic.children.where(type: 'Issue').order(created_at: :desc))
        end

        private

        def find_epic!
          @epic = @project.namespace.epics.find_by(iid: params[:epic_iid])
          not_found! unless @epic
        end
      end
    end
  end
end
