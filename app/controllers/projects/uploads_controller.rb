# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::UploadsController < Projects::ApplicationController
  include UploadsActions
  include WorkhorseRequest

  skip_before_action :authenticate_unless_public!, :authorize_project_access!
  before_action :authenticate_user!, only: [:create, :authorize]
  before_action :authorize_upload_file!, only: [:create, :authorize]
  before_action :verify_workhorse_api!, only: [:authorize]

  private

  def authorize_upload_file!
    render_404 unless can?(current_user, :upload_file, project)
  end

  def upload_model_class
    Project
  end

  def uploader_class
    FileUploader
  end

  def find_model
    @project
  end
end
