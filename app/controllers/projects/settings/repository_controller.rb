# frozen_string_literal: true

module Projects
  module Settings
    class RepositoryController < Projects::Settings::ApplicationController
      layout 'project_settings'

      def edit
        @namespace_settings = project.namespace.namespace_settings || project.namespace.build_namespace_settings
        @protected_branches = project.protected_branches
      end

      def update
        @namespace_settings = project.namespace.namespace_settings || project.namespace.create_namespace_settings!

        if @namespace_settings.update(namespace_settings_params)
          flash.now[:notice] = "Repository settings were successfully updated."
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace('branch_defaults_content', partial: 'projects/settings/repository/branch_defaults_content') }
            format.html { redirect_to edit_namespace_project_settings_repository_path(project.namespace.parent.full_path, project.namespace.path, anchor: 'branch-defaults-settings') }
          end
        else
          flash.now[:alert] = "There was an error updating the repository settings."
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace('branch_defaults_content', partial: 'projects/settings/repository/branch_defaults_content') }
            format.html { render :edit }
          end
        end
      end

      private

      def namespace_settings_params
        params.require(:namespace_setting).permit(:default_branch_name)
      end
    end
  end
end
