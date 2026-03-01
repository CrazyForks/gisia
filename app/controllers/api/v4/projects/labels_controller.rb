# frozen_string_literal: true

module API
  module V4
    module Projects
      class LabelsController < ::API::V4::ProjectBaseController
        before_action :set_label, only: [:show, :update, :destroy]
        before_action :authorize_read_labels!, only: [:index]
        before_action :authorize_admin_label!, only: [:create]
        before_action :authorize_read_label!, only: [:show]
        before_action :authorize_update_label!, only: [:update]
        before_action :authorize_destroy_label!, only: [:destroy]

        def index
          labels = @project.labels
          labels = labels.search_by_title(params[:search]) if params[:search].present?
          @labels = paginate(labels.order(title: :asc))
        end

        def show; end

        def create
          @label = Label.new(create_params)
          @label.namespace = @project.namespace

          if @label.save
            render :show, status: :created
          else
            render json: { message: @label.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @label.update(update_params)
            render :show
          else
            render json: { message: @label.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @label.destroy
          head :no_content
        end

        private

        def authorize_read_labels!
          forbidden! unless current_user.can?(:read_label, @project)
        end

        def authorize_admin_label!
          forbidden! unless current_user.can?(:admin_label, @project)
        end

        def authorize_read_label!
          forbidden! unless current_user.can?(:read_label, @label)
        end

        def authorize_update_label!
          forbidden! unless current_user.can?(:admin_label, @label)
        end

        def authorize_destroy_label!
          forbidden! unless current_user.can?(:admin_label, @label)
        end

        def set_label
          @label = @project.labels.find_by(id: params[:id])
          not_found! unless @label
        end

        def create_params
          params.permit(:title, :color, :description).compact
        end

        def update_params
          params.permit(:title, :color, :description).compact
        end
      end
    end
  end
end
