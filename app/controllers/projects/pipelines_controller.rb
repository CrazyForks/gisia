# frozen_string_literal: true

class Projects::PipelinesController < Projects::ApplicationController
  before_action :authorize_read_pipeline!
  before_action :pipeline, only: [:show, :jobs]

  def index
    @pipelines = project.all_pipelines
    @pipelines = @pipelines.where(status: pipeline_params[:status]) if pipeline_params[:status].present?
    @pipelines = @pipelines.where(ref: pipeline_params[:ref]) if pipeline_params[:ref].present?
    @pipelines = @pipelines.ransack(sha_i_cont: pipeline_params[:search]).result(distinct: true) if pipeline_params[:search].present?
    @pipelines = @pipelines.order(id: :desc).page(params[:page]).per(20)

    @refs = project.ci_refs.pluck(:ref_path).map { |ref_path| ref_path.sub(/\Arefs\/(heads|tags)\//, '') }.compact.sort
    @statuses = Ci::HasStatus::AVAILABLE_STATUSES
  end

  def show; end

  def jobs
    @jobs = pipeline.builds
  end

  private

  def pipeline
    @pipeline = project.all_pipelines.find(params[:id])
  end

  def pipeline_params
    @pipeline_params ||= params.permit(:status, :ref, :search)
  end

  def authorize_read_pipeline!
    forbidden! unless current_user.can?(:read_pipeline, @project)
  end
end
