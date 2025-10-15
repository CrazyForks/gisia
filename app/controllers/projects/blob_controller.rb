# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::BlobController < Projects::ApplicationController
  include ExtractsPath

  before_action :assign_ref_vars, only: [:show]
  before_action :blob, only: [:show]

  def show
  end

  def blob
    request.format = :html

    return unless commit

    blob_raw = @repository.blob_at(@ref, @path)
    @blob = Blob.decorate(blob_raw, @project)

    return head :not_found unless @blob
  end

  def commit
    @commit = @repository.commit(@ref)
  end

  private

  def ref_params
    { id: params[:id]}
  end
end
