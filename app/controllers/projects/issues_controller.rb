class Projects::IssuesController < Projects::ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy, :close, :reopen]
  before_action :set_counts, only: [:index]

  def index
    status_param = params[:status].presence || 'opened'
    search_params = {
      state_id_eq: WorkItems::HasState::STATE_ID_MAP[status_param],
      author_id_eq: params[:author_id],
      title_or_description_i_cont: params[:search]
    }.compact

    @issues = @project.namespace.work_items.where(type: 'Issue')
                     .ransack(search_params)
                     .result(distinct: true)
                     .includes(:author, :updated_by, :closed_by, :labels)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(20)
  end

  def show
    @notes = @issue.notes.root_notes.inc_relations_for_view.fresh
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.namespace = @project.namespace
    @issue.author = current_user

    if @issue.save
      redirect_to namespace_project_issue_path(@project.namespace.parent.full_path, @project.path, @issue), notice: 'Issue was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @issue.updated_by = current_user

    if @issue.update(issue_params)
      respond_to do |format|
        format.html do
          redirect_to namespace_project_issue_path(@project.namespace.parent.full_path, @project.path, @issue), notice: 'Issue was successfully updated.'
        end
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @issue.destroy
    redirect_to namespace_project_issues_path(@project.namespace.parent.full_path, @project.path), notice: 'Issue was successfully deleted.'
  end

  def close
    @issue.close!(current_user)
    redirect_to namespace_project_issue_path(@project.namespace.parent.full_path, @project.path, @issue), notice: 'Issue was closed.'
  end

  def reopen
    @issue.reopen!
    redirect_to namespace_project_issue_path(@project.namespace.parent.full_path, @project.path, @issue), notice: 'Issue was reopened.'
  end

  def search_users
    @users = @project.users.limit(10)

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

  def search_labels
    @labels = @project.namespace.labels.limit(10)

    @labels = @labels.ransack(title_cont: params[:q]).result if params[:q]

    @selected_ids = params[:selected_ids]&.split(',')&.map(&:to_i) || []

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_issue
    @issue = @project.namespace.work_items.where(type: 'Issue').find(params[:id])
  end

  def set_counts
    @opened_count = @project.namespace.work_items.where(type: 'Issue', state_id: WorkItems::HasState::STATE_ID_MAP['opened']).count
    @closed_count = @project.namespace.work_items.where(type: 'Issue', state_id: WorkItems::HasState::STATE_ID_MAP['closed']).count
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :confidential, :due_date, assignee_ids: [], label_ids: [])
  end
end