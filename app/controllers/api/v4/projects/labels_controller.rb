# frozen_string_literal: true

module API
  module V4
    module Projects
      class LabelsController < ::API::V4::ProjectBaseController
        before_action :set_label, only: [:show, :update, :destroy]

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
