# frozen_string_literal: true

class Projects::PipelinesController < Projects::ApplicationController
  before_action :pipeline, only: [:show, :jobs]

  def index
    @pipelines = project.all_pipelines

    if params[:status].present?
      @pipelines = @pipelines.where(status: params[:status])
    end

    if params[:ref].present?
      @pipelines = @pipelines.where(ref: params[:ref])
    end

    @pipelines = @pipelines.ransack(sha_i_cont: params[:search]).result(distinct: true) if params[:search].present?

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
end
