# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::JobsController < Projects::ApplicationController
  include SendFileUpload
  include WorkhorseHelper

  before_action :job, only: [:show, :raw]

  def index
    @jobs = project.builds

    if params[:status].present?
      @jobs = @jobs.where(status: params[:status])
    end

    @jobs = @jobs.order(id: :desc).page(params[:page]).per(20)
    @statuses = Ci::HasStatus::AVAILABLE_STATUSES
  end

  def show; end

  def raw
    if @job.trace.archived?
      workhorse_set_content_type!
      send_upload(@job.job_artifacts_trace.file, send_params: raw_send_params, redirect_params: raw_redirect_params,
        proxy: params[:proxy])
    else
      @job.trace.read do |stream|
        if stream.file?
          workhorse_set_content_type!
          send_file stream.path, type: 'text/plain; charset=utf-8', disposition: 'inline'
        else
          raw_data = stream.raw
          send_data raw_data, type: 'text/plain; charset=utf-8', disposition: raw_trace_content_disposition(raw_data),
            filename: 'job.log'
        end
      end
    end
  end

  private

  def job
    @job = project.builds.find(params[:id])
  end

  def raw_send_params
    { type: 'text/plain; charset=utf-8', disposition: 'inline' }
  end

  def raw_redirect_params
    { query: { 'response-content-type' => 'text/plain; charset=utf-8', 'response-content-disposition' => 'inline' } }
  end

  def raw_trace_content_disposition(raw_data)
    return 'inline' if raw_data.nil? || raw_data.encoding == Encoding::UTF_8

    'attachment'
  end
end

