# frozen_string_literal: true

module API
  module V4
    class ProjectsController < ::API::V4::UserBaseController
      include API::V4::ProjectFindable

      before_action :find_project!, only: [:show, :update, :destroy]
      before_action -> { authorize_project!(:admin_project) }, only: [:update]
      before_action -> { authorize_project!(:remove_project) }, only: [:destroy]

      def index
        projects = Project.where(id: current_user.projects)
        projects = projects.search(params[:search]) if params[:search].present?
        @projects = paginate(projects.order(id: :desc))
      end

      def show; end

      def create
        @project = Project.new(create_params(current_user.id).merge(creator_id: current_user.id))
        if @project.save
          render :show, status: :created
        else
          render json: { message: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @project.update(update_params)
          render :show
        else
          render json: { message: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @project.destroy!
        head :no_content
      end

      private

      def authorize_project!(ability)
        forbidden! unless Ability.allowed?(current_user, ability, @project)
      end

      def create_params(creator_id = nil)
        p = params.permit(:name, :path, :description, :namespace_id, :visibility_level).compact
        p[:namespace_parent_id] = p.delete(:namespace_id) if p[:namespace_id]
        vl = p.delete(:visibility_level)
        p[:namespace_attributes] = { visibility_level: vl, creator_id: creator_id } if vl
        p
      end

      def update_params
        params.permit(:name, :description, :visibility_level).compact
      end
    end
  end
end
