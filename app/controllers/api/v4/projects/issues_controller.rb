# frozen_string_literal: true

module API
  module V4
    module Projects
      class IssuesController < ::API::V4::ProjectBaseController
        include API::V4::IssueFilterable

        before_action :find_issue!, only: [:show, :update, :destroy]

        def index
          @issues = paginate(apply_filters(@project.issues).order(created_at: :desc))
        end

        def show; end

        def create
          @issue = Issue.new(create_params)
          @issue.namespace = @project.namespace
          @issue.author = current_user

          if @issue.save
            handle_assignees(@issue, params[:assignee_ids])
            handle_labels(@issue, params[:label_ids])
            render :show, status: :created
          else
            render json: { message: @issue.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          handle_state_event
          handle_add_labels
          handle_remove_labels

          if @issue.update(update_params)
            handle_assignees(@issue, params[:assignee_ids]) if params[:assignee_ids]
            render :show
          else
            render json: { message: @issue.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @issue.destroy
          head :no_content
        end

        private

        def find_issue!
          @issue = @project.issues.find_by(iid: params[:issue_iid])
          not_found! unless @issue
        end

        def label_scope
          Label.where(namespace_id: @project.namespace_id)
        end

        def handle_state_event
          case params[:state_event]
          when 'close'
            @issue.close(current_user) unless @issue.closed?
          when 'reopen'
            @issue.reopen unless @issue.opened?
          end
        end

        def handle_assignees(issue, assignee_ids)
          return unless assignee_ids

          issue.assignees = User.where(id: Array(assignee_ids))
        end

        def handle_labels(issue, label_ids)
          return if label_ids.blank?

          issue.labels = label_scope.where(id: Array(label_ids))
        end

        def handle_add_labels
          return if params[:add_label_ids].blank?

          @issue.labels |= label_scope.where(id: Array(params[:add_label_ids]))
        end

        def handle_remove_labels
          return if params[:remove_label_ids].blank?

          @issue.labels = @issue.labels.reject { |l| Array(params[:remove_label_ids]).map(&:to_i).include?(l.id) }
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
