# frozen_string_literal: true

module API
  module V4
    class NamespacesController < ::API::V4::UserBaseController
      before_action :find_namespace!, only: [:show, :update, :destroy]
      before_action -> { authorize_namespace!(:admin_namespace) }, only: [:update]
      before_action -> { authorize_namespace!(:remove_namespace) }, only: [:destroy]

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

      def authorize_namespace!(ability)
        forbidden! unless Ability.allowed?(current_user, ability, @namespace)
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
