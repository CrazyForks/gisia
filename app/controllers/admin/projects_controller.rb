# frozen_string_literal: true

class Admin::ProjectsController < Admin::ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :set_project_stats, only: [:index]

  def index
    @projects = Project.joins(:namespace)

    if params[:visibility].present?
      visibility = Gitlab::VisibilityLevel.level_value(params[:visibility])
      @projects = @projects.joins(:namespace).where(namespaces: { visibility_level: visibility })
    end

    @projects = @projects.ransack(name_i_cont: params[:search]).result(distinct: true) if params[:search].present?

    @projects = @projects.order(id: :desc).page(params[:page]).per(20)
  end

  def show
    @project_members = @project.members.includes(:user).limit(10)
    @issues_count = 0
    @merge_requests_count = @project.merge_requests.count
    @pipelines_count = @project.all_pipelines.count
  end

  def edit; end

  def update
    update_result = @project.update!(project_params)

    if update_result
      redirect_to admin_project_path(@project), notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to admin_projects_path, notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def set_project_stats
    @projects_count = Namespaces::ProjectNamespace.count
    @public_projects_count = Namespaces::ProjectNamespace.public_only.count
    @internal_projects_count = Namespaces::ProjectNamespace.internal_only.count
    @private_projects_count = Namespaces::ProjectNamespace.private_only.count
  end

  def project_params
    params.require(:project).permit(:name, :description, namespace_attributes: %i[id visibility_level])
  end
end
