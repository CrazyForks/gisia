module Projects
  module Settings
    class LabelsController < Projects::ApplicationController
      include LabelsHelper
      before_action :set_label, only: [:edit_form, :update, :destroy]

      def index
        @labels = @project.namespace.labels.order(id: :desc)

        respond_to do |format|
          format.html
          format.turbo_stream { render :index }
        end
      end

      def new_form
        @label = @project.namespace.labels.build

        respond_to do |format|
          format.html
          format.turbo_stream { render :new_form }
        end
      end

      def edit_form
        respond_to do |format|
          format.html
          format.turbo_stream { render :edit_form }
        end
      end

      def create
        @label = @project.namespace.labels.build(label_params)

        if @label.save
          @labels = @project.namespace.labels.order(id: :desc)

          respond_to do |format|
            format.turbo_stream { render :create }
            format.html { redirect_to labels_path(@project), notice: 'Label was successfully created.' }
          end
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @label.update(label_params)
          redirect_to labels_path(@project),
            notice: 'Label was successfully updated.'
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @label.destroy

        respond_to do |format|
          format.turbo_stream { render :destroy }
          format.html { redirect_to labels_path(@project), notice: 'Label was successfully deleted.' }
        end
      end

      private

      def set_label
        @label = @project.namespace.labels.find(params[:id])
      end

      def label_params
        params.require(:label).permit(:title, :description, :color, :rank)
      end
    end
  end
end

