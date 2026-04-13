# frozen_string_literal: true

module API
  module V4
    module Projects
      class MembersController < ::API::V4::ProjectBaseController
        before_action :find_member!, only: [:show, :update, :destroy]
        before_action :authorize_manage_members!, only: [:create, :update, :destroy]

        def index
          @members = ProjectMember.with_project(@project).includes(:user)
        end

        def show; end

        def create
          user = User.find_by(id: params[:user_id])
          return not_found! unless user

          @member = ProjectMember.new(
            user: user,
            namespace: @project.namespace,
            access_level: params[:access_level],
            created_by: current_user
          )

          if @member.save
            render :show, status: :created
          else
            render json: { message: @member.errors.full_messages }, status: :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotUnique
          render json: { message: ['User is already a member of this project'] }, status: :unprocessable_entity
        end

        def update
          if @member.update(access_level: params[:access_level])
            render :show
          else
            render json: { message: @member.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @member.destroy
          head :no_content
        end

        private

        def find_member!
          @member = ProjectMember.with_project(@project).find_by(user_id: params[:user_id])
          not_found! unless @member
        end

        def authorize_manage_members!
          return if current_user.admin?

          member = ProjectMember.with_project(@project).find_by(user_id: current_user.id)
          forbidden! unless member&.maintainer? || member&.owner?
        end
      end
    end
  end
end
