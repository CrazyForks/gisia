# frozen_string_literal: true

class Dashboard::ProjectsController < Dashboard::ApplicationController
  before_action :set_project, only: %i[destroy]
  before_action :set_available_namespaces, only: %i[new create]
  before_action :verify_namespace_ownership, only: %i[create]

  def index
    @projects = current_user.projects.order(id: :desc)
  end

  def new
    @project = Project.new
    @project.build_namespace
  end

  def create
    @project = Project.new(params_for_create)

    if @project.save
      redirect_to "/#{@project.full_path}", notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @project.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_projects_path }
    end
  end

  private

  def set_project
    @project = Project.includes(:namespace).find(params[:id])
  end

  def params_for_create
    create_project_params.tap do |params|
      params[:namespace_attributes][:creator_id] = current_user.id
    end
  end

  def create_project_params
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
      redirect_to dashboard_projects_path, alert: 'You are not authorized to use this namespace.'
    end
  end
end
