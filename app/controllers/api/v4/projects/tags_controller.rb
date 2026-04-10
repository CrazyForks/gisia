# frozen_string_literal: true

module API
  module V4
    module Projects
      class TagsController < ::API::V4::ProjectBaseController
        before_action :authorize_read_tags!, only: [:index, :show]
        before_action :authorize_write_tags!, only: [:create]
        before_action -> { require_params!(:tag, :ref) }, only: [:create]
        before_action :authorize_create_protected_tag!, only: [:create]
        before_action :find_tag!, only: [:show, :destroy]
        before_action :authorize_delete_tag!, only: [:destroy]

        def index
          tags = TagsFinder.new(@project.repository, declared_params).execute
          @tags = paginate(Kaminari.paginate_array(tags))
        end

        def show
        end

        def create
          @tag = @project.repository.create_tag(current_user, params[:tag], params[:ref], params[:message])

          if @tag
            render :show, status: :created
          else
            render json: { message: @project.repository.errors.full_messages.first }, status: :bad_request
          end
        end

        def destroy
          if @project.repository.destroy_tag(current_user, params[:name])
            head :no_content
          else
            render json: { message: @project.repository.errors.full_messages.first }, status: :bad_request
          end
        end

        private

        def require_params!(*keys)
          missing = keys.select { |k| !params[k].is_a?(String) || params[k].blank? }
          render json: { message: "#{missing.join(', ')} is missing" }, status: :bad_request if missing.any?
        end

        def authorize_read_tags!
          forbidden! unless current_user.can?(:download_code, @project)
        end

        def authorize_write_tags!
          forbidden! unless current_user.can?(:admin_tag, @project)
        end

        def authorize_create_protected_tag!
          return unless ProtectedTag.protected?(@project, params[:tag])

          forbidden! unless @project.protected_tags.allowed?(current_user.max_access(@project), params[:tag])
        end

        def find_tag!
          @tag = @project.repository.find_tag(params[:name])
          not_found! unless @tag
        end

        def authorize_delete_tag!
          forbidden! unless current_user.can?(:delete_tag, @tag)
        end

        def declared_params
          params.permit(:search, :sort).to_h.symbolize_keys
        end
      end
    end
  end
end
