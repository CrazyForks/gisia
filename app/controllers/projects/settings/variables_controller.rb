# frozen_string_literal: true

module Projects
  module Settings
    class VariablesController < Projects::Settings::ApplicationController
      def create
        @variable = @project.namespace.variables.build(variable_params)

        if @variable.save
          flash.now[:notice] = 'Variable was successfully created.'
        else
          flash.now[:alert] = @variable.errors.full_messages.join(', ')
        end

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('variables_content',
              render_to_string(partial: 'projects/settings/variables/variables_content'))
          end
          format.html do
            redirect_to edit_namespace_project_settings_ci_cd_path(@project.namespace.parent.full_path,
              @project.namespace.path)
          end
        end
      end

      def update
        @variable = @project.namespace.variables.find(params[:id])

        if @variable.update(variable_params)
          flash.now[:notice] = 'Variable was successfully updated.'
        else
          flash.now[:alert] = @variable.errors.full_messages.join(', ')
        end

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('variables_content',
              render_to_string(partial: 'projects/settings/variables/variables_content'))
          end
          format.html do
            redirect_to edit_namespace_project_settings_ci_cd_path(@project.namespace.parent.full_path,
              @project.namespace.path)
          end
        end
      end

      def destroy
        @variable = @project.namespace.variables.find(params[:id])
        @variable.destroy

        respond_to do |format|
          flash.now[:notice] = 'Variable was successfully deleted.'

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('variables_content',
              render_to_string(partial: 'projects/settings/variables/variables_content'))
          end
          format.html do
            redirect_to edit_namespace_project_settings_ci_cd_path(@project.namespace.parent.full_path,
              @project.namespace.path)
          end
        end
      end

      private

      def variable_params
        params.require(:variable).permit(:key, :value, :protected, :masked, :raw, :description)
      end
    end
  end
end
