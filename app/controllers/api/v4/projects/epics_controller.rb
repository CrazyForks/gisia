# frozen_string_literal: true

module API
  module V4
    module Projects
      class EpicsController < ::API::V4::ProjectBaseController
        include API::V4::IssueFilterable
        include ::Projects::IssueAuthorizable

        before_action :find_epic!, only: [:show, :update, :destroy]
        before_action :authorize_read_issues!, only: [:index]
        before_action :authorize_create_issue!, only: [:create]
        before_action :authorize_read_issuable!, only: [:show]
        before_action :authorize_update_issuable!, only: [:update]
        before_action :authorize_destroy_issuable!, only: [:destroy]

        def index
          @epics = paginate(apply_filters(@project.namespace.epics).order(created_at: :desc))
        end

        def show; end

        def create
          @epic = @project.namespace.epics.build(create_params)
          @epic.author = current_user

          if @epic.save
            render :show, status: :created
          else
            render json: { message: @epic.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          handle_state_event

          if @epic.update(update_params)
            render :show
          else
            render json: { message: @epic.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @epic.destroy
          head :no_content
        end

        private

        def issuable_resource
          @epic
        end

        def find_epic!
          @epic = @project.namespace.epics.find_by(iid: params[:epic_iid])
          not_found! unless @epic
        end

        def label_scope
          Label.where(namespace_id: @project.namespace_id)
        end

        def handle_state_event
          case params[:state_event]
          when 'close'
            @epic.close!(current_user) unless @epic.closed?
          when 'reopen'
            @epic.reopen! unless @epic.opened?
          end
        end

        def create_params
          params.permit(:title, :description, :due_date, :confidential).compact
        end

        def update_params
          params.permit(:title, :description, :due_date, :confidential).compact
        end
      end
    end
  end
end
