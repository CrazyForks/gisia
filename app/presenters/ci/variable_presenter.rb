# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  class VariablePresenter < Gitlab::View::Presenter::Delegated
    presents ::Ci::Variable, as: :variable

    def placeholder
      'PROJECT_VARIABLE'
    end

    def form_path
      project_settings_ci_cd_path(project)
    end

    def edit_path
      project_variables_path(project)
    end

    def delete_path
      project_variables_path(project)
    end
  end
end
