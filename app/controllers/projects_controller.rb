# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class ProjectsController < Projects::ApplicationController
  include ExtractsPath
  include TreeViewable

  before_action :check_empty_repository, only: [:show]
  before_action :assign_ref_vars, only: [:show]
  before_action :set_tree, only: [:show]
  before_action :set_available_namespaces, only: %i[edit update]
  before_action :verify_namespace_ownership, only: %i[update]

  def index; end

  def new; end

  def edit
    @project.build_namespace unless @project.namespace
    @project.namespace_parent_id = @project.namespace&.parent_id
  end

  def create; end

  def update
    if @project.update(project_params)
      redirect_to namespace_project_path(@project.namespace.parent.full_path, @project.path), notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy; end

  def show;end

  private

  def check_empty_repository
    return unless @project.repository_exists? && @project.empty_repo?

    render 'empty'
  end

  def project_params
    params.require(:project).permit(
      :name,
      :path,
      :description,
      :namespace_parent_id,
      namespace_attributes: %i[id parent_id visibility_level]
    )
  end

  def set_available_namespaces
    @available_namespaces = available_namespaces_for_user
  end

  def available_namespaces_for_user
    user_namespace = [current_user.namespace]
    group_namespaces = current_user.groups.map(&:namespace)
    user_namespace + group_namespaces
  end

  def verify_namespace_ownership
    return unless params[:project]&.dig(:namespace_parent_id).present?

    namespace_parent_id = params[:project][:namespace_parent_id].to_i
    available_namespace_ids = available_namespaces_for_user.map(&:id)

    unless available_namespace_ids.include?(namespace_parent_id)
      redirect_to namespace_project_path(@project.namespace.parent.full_path, @project.path), alert: 'You are not authorized to use this namespace.'
    end
  end
end
