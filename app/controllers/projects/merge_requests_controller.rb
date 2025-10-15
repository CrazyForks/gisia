# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::MergeRequestsController < Projects::ApplicationController
  before_action :feature_disabled
  before_action :define_new_vars, only: %i[new edit]
  before_action :set_mr, only: %i[show commits diffs pipelines edit update merge close]
  before_action :set_counts, only: [:index]
  before_action :check_mr_author_authorization, only: [:update]

  def index
    status_param = params[:status].presence || 'opened'
    search_params = {
      status_eq: MergeRequest.statuses[status_param],
      assignees_id_eq: params[:assignee_id],
      reviewers_id_eq: params[:reviewer_id],
      author_id_eq: params[:author_id],
      title_or_description_i_cont: params[:search]
    }.compact

    @merge_requests = project.merge_requests.ransack(search_params)
                             .result(distinct: true)
                             .includes(:author, :assignees, :reviewers)
                             .order(id: :desc)
                             .page(params[:page])
                             .per(20)
  end

  def new; end

  def show
    @notes = @merge_request.notes.inc_relations_for_view.fresh
  end

  def commits
    @commits = @merge_request.recent_commits
  end

  def create
    @merge_request = MergeRequest.new(merge_request_params.merge(author_id: current_user.id, target_project: project,
      source_project: project))

    if @merge_request.save
      redirect_to namespace_project_merge_request_path(@merge_request.target_project.namespace.parent.full_path, @merge_request.target_project.path, @merge_request),
        notice: 'Merge request was successfully created.'
    else
      define_new_vars
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @merge_request.update(merge_request_params)
      respond_to do |format|
        format.html do
          redirect_to namespace_project_merge_request_path(@merge_request.target_project.namespace.parent.full_path, @merge_request.target_project.path, @merge_request),
            notice: 'Merge request was successfully updated.'
        end
        format.json { render json: { status: 'success', message: 'Merge request was successfully updated.' } }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { status: 'error', errors: @merge_request.errors }, status: :unprocessable_entity }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  def merge
    if @merge_request.opened?
      @merge_request.update!(status: 'merged', merged_at: Time.current, merge_user: current_user)
      redirect_to namespace_project_merge_request_path(@merge_request.target_project.namespace.parent.full_path, @merge_request.target_project.path, @merge_request),
        notice: 'Merge request was successfully merged.'
    else
      redirect_to namespace_project_merge_request_path(@merge_request.target_project.namespace.parent.full_path, @merge_request.target_project.path, @merge_request),
        alert: 'Merge request cannot be merged.'
    end
  end

  def close
    @merge_request.update!(status: 'closed')
    redirect_to namespace_project_merge_request_path(@merge_request.target_project.namespace.parent.full_path, @merge_request.target_project.path, @merge_request),
      notice: 'Merge request was closed.'
  end

  def diffs
    @diffs = @merge_request.diffs
  end

  def pipelines
    @pipelines = @merge_request.pipelines
  end

  def search_users
    @users = project.users.limit(10)

    @users = if params[:ids]
               @users.where(id: params[:ids].split(',').map(&:to_i))
             elsif params[:q]
               @users.ransack(username_or_name_cont: params[:q]).result
             end

    @field_type = params[:field_type] || 'assignees'
    @selected_ids = params[:selected_ids]&.split(',')&.map(&:to_i) || []

    respond_to do |format|
      format.json
      format.turbo_stream
    end
  end

  private

  def feature_disabled
    head :not_found
  end

  def merge_request_params
    params.require(:merge_request).permit(:source_project_id, :source_branch, :target_project_id, :target_branch, :title, :description,
      assignee_ids: [], reviewer_ids: [])
  end

  def define_new_vars
    @merge_request = MergeRequest.new(source_project: project, target_project: project)
    @branches = project.repository.branch_names
    @projects = Project.all
    @users = User.all
  end

  def set_mr
    @merge_request = MergeRequest.includes(:assignees, :reviewers).find(params[:id])
  end

  def set_counts
    @opened_count = project.merge_requests.opened.count
    @merged_count = project.merge_requests.merged.count
    @closed_count = project.merge_requests.closed.count
  end

  def check_mr_author_authorization
    unless @merge_request.author == current_user
      respond_to do |format|
        format.html { redirect_to namespace_project_merge_request_path(@merge_request.target_project.namespace.parent.full_path, @merge_request.target_project.path, @merge_request), alert: 'You are not authorized to update this merge request.' }
        format.json { render json: { error: 'You are not authorized to update this merge request.' }, status: :forbidden }
      end
    end
  end
end
