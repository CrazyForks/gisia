class Projects::EpicsController < Projects::ApplicationController
  before_action :set_epic, only: [:show, :edit, :update, :destroy, :close, :reopen]
  before_action :set_counts, only: [:index]

  def index
    status_param = params[:status].presence || 'opened'
    search_params = {
      state_id_eq: WorkItems::HasState::STATE_ID_MAP[status_param],
      author_id_eq: params[:author_id],
      title_or_description_i_cont: params[:search]
    }.compact

    @epics = @project.namespace.work_items.where(type: 'Epic')
                     .ransack(search_params)
                     .result(distinct: true)
                     .includes(:author, :updated_by, :closed_by)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(20)
  end

  def show
    @notes = @epic.notes.root_notes.inc_relations_for_view.fresh
  end

  def new
    @epic = Epic.new
  end

  def create
    @epic = Epic.new(epic_params)
    @epic.namespace = @project.namespace
    @epic.author = current_user

    if @epic.save
      redirect_to namespace_project_epic_path(@project.namespace.parent.full_path, @project.path, @epic), notice: 'Epic was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @epic.updated_by = current_user

    if @epic.update(epic_params)
      respond_to do |format|
        format.html { redirect_to namespace_project_epic_path(@project.namespace.parent.full_path, @project.path, @epic), notice: 'Epic was successfully updated.' }
        format.turbo_stream { render :update }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @epic.destroy
    redirect_to namespace_project_epics_path(@project.namespace.parent.full_path, @project.path), notice: 'Epic was successfully deleted.'
  end

  def close
    @epic.close!(current_user)
    redirect_to namespace_project_epic_path(@project.namespace.parent.full_path, @project.path, @epic), notice: 'Epic was closed.'
  end

  def reopen
    @epic.reopen!
    redirect_to namespace_project_epic_path(@project.namespace.parent.full_path, @project.path, @epic), notice: 'Epic was reopened.'
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

  def set_epic
    @epic = @project.namespace.work_items.where(type: 'Epic').find(params[:id])
  end

  def set_counts
    @opened_count = @project.namespace.work_items.where(type: 'Epic', state_id: WorkItems::HasState::STATE_ID_MAP['opened']).count
    @closed_count = @project.namespace.work_items.where(type: 'Epic', state_id: WorkItems::HasState::STATE_ID_MAP['closed']).count
  end

  def epic_params
    params.require(:epic).permit(:title, :description, :confidential, :due_date, assignee_ids: [], label_ids: [])
  end
end