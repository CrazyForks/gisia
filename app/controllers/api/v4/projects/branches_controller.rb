# frozen_string_literal: true

module API
  module V4
    module Projects
      class BranchesController < ::API::V4::ProjectBaseController
        before_action :authorize_read_branches!, only: [:index, :show, :check]
        before_action :authorize_push_branches!, only: [:create, :destroy]

        def index
          branches = BranchesFinder.new(@project.repository, declared_params).execute
          @branches = paginate(Kaminari.paginate_array(branches))
          @merged_branch_names = @project.repository.merged_branch_names(@branches.map(&:name))
        rescue RegexpError
          render json: { message: 'Regex is invalid' }, status: :bad_request
        end

        def check
          if @project.repository.branch_exists?(params[:name])
            head :no_content
          else
            head :not_found
          end
        end

        def show
          @branch = @project.repository.find_branch(params[:name])
          not_found! unless @branch
        end

        def create
          return render json: { message: 'branch is missing' }, status: :bad_request if params[:branch].blank?
          return render json: { message: 'ref is missing' }, status: :bad_request if params[:ref].blank?

          result = Branches::CreateService.new(@project, current_user)
            .execute(params[:branch], params[:ref])

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

        def declared_params
          params.permit(:search, :regex, :sort).to_h.symbolize_keys
        end
      end
    end
  end
end
