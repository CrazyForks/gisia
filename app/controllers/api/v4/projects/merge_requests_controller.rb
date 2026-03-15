# frozen_string_literal: true

module API
  module V4
    module Projects
      class MergeRequestsController < ::API::V4::ProjectBaseController
        include ::Projects::MergeRequestAuthorizable

        before_action :find_merge_request!, only: [:show, :update, :destroy]
        before_action :authorize_read_merge_requests!, only: [:index]
        before_action :authorize_create_merge_request!, only: [:create]
        before_action :authorize_read_merge_request!, only: [:show]
        before_action :authorize_update_merge_request!, only: [:update]
        before_action :authorize_destroy_merge_request!, only: [:destroy]
        before_action :authorize_author!, only: [:update, :destroy]

        def index
          state = params[:state].presence
          search_params = {
            status_eq: (state && state != 'all') ? MergeRequest.statuses[state] : nil,
            assignees_id_eq: params[:assignee_id],
            reviewers_id_eq: params[:reviewer_id],
            author_id_eq: params[:author_id],
            title_or_description_i_cont: params[:search],
            source_branch_eq: params[:source_branch],
            target_branch_eq: params[:target_branch]
          }.compact

          mrs = @project.merge_requests
            .ransack(search_params)
            .result(distinct: true)
            .includes(:author, :assignees, :reviewers, :metrics, target_project: { namespace: :parent })
            .order(id: :desc)

          @merge_requests = paginate(mrs)
        end

        def show; end

        def create
          @merge_request = MergeRequest.new(create_params)
          @merge_request.author = current_user
          @merge_request.source_project = @project
          @merge_request.target_project = @project

          if @merge_request.save
            handle_assignees(params[:assignee_ids])
            handle_reviewers(params[:reviewer_ids])
            render :show, status: :created
          else
            render json: { message: @merge_request.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          success = false

          ApplicationRecord.transaction do
            handle_state_event
            success = @merge_request.update(update_params)
            raise ActiveRecord::Rollback unless success
          end

          if success
            handle_assignees(params[:assignee_ids]) if params[:assignee_ids]
            handle_reviewers(params[:reviewer_ids]) if params[:reviewer_ids]
            render :show
          else
            render json: { message: @merge_request.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @merge_request.destroy
          head :no_content
        end

        private

        def find_merge_request!
          @merge_request = @project.merge_requests
            .includes(:author, :assignees, :reviewers, :metrics, target_project: { namespace: :parent })
            .find_by(iid: params[:merge_request_iid])
          not_found! unless @merge_request
        end

        def authorize_author!
          forbidden! unless @merge_request.author == current_user
        end

        def handle_state_event
          case params[:state_event]
          when 'close'
            @merge_request.close! unless @merge_request.closed?
          when 'reopen'
            @merge_request.reopen! unless @merge_request.opened?
          end
        end

        def handle_assignees(assignee_ids)
          return unless assignee_ids

          @merge_request.assignees = User.where(id: Array(assignee_ids))
        end

        def handle_reviewers(reviewer_ids)
          return unless reviewer_ids

          @merge_request.reviewers = User.where(id: Array(reviewer_ids))
        end

        def create_params
          p = params.permit(:source_branch, :target_branch, :title, :description).compact
          p[:title] = "Merge #{p[:source_branch]} into #{p[:target_branch]}" if p[:title].blank?
          p
        end

        def update_params
          params.permit(:title, :description).compact
        end
      end
    end
  end
end
