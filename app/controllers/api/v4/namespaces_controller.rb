# frozen_string_literal: true

module API
  module V4
    class NamespacesController < ::API::V4::UserBaseController
      before_action :find_namespace!, only: [:show, :update, :destroy]
      before_action :authorize_manage_namespace!, only: [:update]
      before_action :authorize_destroy_namespace!, only: [:destroy]

      def index
        namespaces = user_namespaces
        namespaces = namespaces.search(params[:search]) if params[:search].present?
        @namespaces = paginate(namespaces.with_route.order(:id))
      end

      def show; end

      def create
        @group = Group.new(create_params)
        @group.build_namespace unless @group.namespace
        @group.namespace.creator = current_user
        if @group.save
          @namespace = @group.namespace
          render :show, status: :created
        else
          render json: { message: @group.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        resource = @namespace.group_namespace? ? @namespace.group : @namespace
        if resource.update(update_params)
          render :show
        else
          render json: { message: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @namespace.group.destroy
        head :no_content
      end

      private

      def find_namespace!
        ns = Namespace.without_project_namespaces.find_by_id_or_path(params[:id])
        not_found! unless ns && user_namespaces.exists?(id: ns.id)
        @namespace = ns
      end

      def user_namespaces
        current_user.accessible_namespaces
      end

      def authorize_manage_namespace!
        return if current_user.admin?
        return if @namespace == current_user.namespace
        return if @namespace.group_namespace? &&
          @namespace.group.members.with_user(current_user)
            .with_at_least_access_level(Accessible::MAINTAINER).exists?

        forbidden!
      end

      def authorize_destroy_namespace!
        return forbidden! unless @namespace.group_namespace?
        return if current_user.admin?
        return if @namespace.group.members.with_user(current_user)
          .with_at_least_access_level(Accessible::OWNER).exists?

        forbidden!
      end

      def create_params
        params.permit(:name, :path, :description, :visibility_level, :parent_id).compact
      end

      def update_params
        params.permit(:name, :path, :description, :visibility_level).compact
      end
    end
  end
end
