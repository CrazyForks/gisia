# frozen_string_literal: true

module API
  module V4
    module Projects
      class EpicsController < ::API::V4::ProjectBaseController
        include API::V4::IssueFilterable

        before_action :find_epic!, only: [:show, :update, :destroy]

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
