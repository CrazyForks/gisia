# frozen_string_literal: true

class Admin::GroupsController < Admin::ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  def index
    base_groups = Group.includes(:namespace, :route, :members)
    @groups = base_groups.order('namespaces.name ASC')

    # Apply search filter
    if params[:search].present?
      @groups = @groups.joins(:namespace).where('namespaces.name ILIKE ? OR namespaces.path ILIKE ?',
        "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # Apply visibility filter
    if params[:visibility].present?
      visibility_level = case params[:visibility]
                         when 'public' then Gitlab::VisibilityLevel::PUBLIC
                         when 'internal' then Gitlab::VisibilityLevel::INTERNAL
                         when 'private' then Gitlab::VisibilityLevel::PRIVATE
                         end
      @groups = @groups.joins(:namespace).where(namespaces: { visibility_level: visibility_level }) if visibility_level
    end

    # Calculate stats from filtered groups for display in cards
    @groups_count = @groups.count

    # Paginate the filtered results
    @groups = @groups.page(params[:page]).per(20)
  end

  def show
    @members = @group.members.includes(:user).limit(10)
    @projects = @group.namespace.descendant_projects.includes(:namespace).limit(10)
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to admin_group_path(@group), notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to admin_groups_path, notice: 'Group was successfully deleted.'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_groups_path, alert: 'Group not found.'
  end

  def group_params
    params.require(:group).permit(:name, :path, :description)
  end
end
