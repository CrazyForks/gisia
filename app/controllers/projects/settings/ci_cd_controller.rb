# frozen_string_literal: true

module Projects
  module Settings
    class CiCdController < Projects::ApplicationController
      layout 'project_settings'

      def edit
        @pipeline_settings = project.pipeline_settings || project.build_pipeline_settings
        @ci_cd_settings = project.ci_cd_settings || project.build_ci_cd_settings
      end
    end
  end
end