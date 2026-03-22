# frozen_string_literal: true

module API
  module V4
    module Projects
      class BranchesController < ::API::V4::ProjectBaseController
        before_action :authorize_read_branches!, only: [:index, :show]
        before_action :authorize_push_branches!, only: [:create, :destroy]

        def index
          branches = @project.repository.local_branches.sort_by(&:name)

          if params[:search].present?
            search_term = params[:search].downcase
            branches = branches.select { |b| b.name.downcase.include?(search_term) }
          end

          @branches = branches
        end

        def show
          @branch = @project.repository.find_branch(params[:name])
          not_found! unless @branch
        end

        def create
          branch_params = params.permit(:branch, :ref)
          result = Branches::CreateService.new(@project, current_user)
            .execute(branch_params[:branch], branch_params[:ref])

          if result[:status] == :success
            @branch = result[:branch]
            render :show, status: :created
          else
            render json: { message: result[:message] }, status: :bad_request
          end
        end

        def destroy
          if ProtectedBranch.protected?(@project, params[:name])
            return render json: { message: 'Cannot delete a protected branch' }, status: :forbidden
          end

          if @project.default_branch == params[:name]
            return render json: { message: 'Cannot delete the default branch' }, status: :forbidden
          end

          result = Branches::DeleteService.new(@project, current_user).execute(params[:name])

          if result.success?
            head :no_content
          else
            render json: { message: result.message }, status: result.http_status
          end
        end

        private

        def authorize_read_branches!
          forbidden! unless current_user.can?(:download_code, @project)
        end

        def authorize_push_branches!
          forbidden! unless current_user.can?(:push_code, @project)
        end
      end
    end
  end
end
