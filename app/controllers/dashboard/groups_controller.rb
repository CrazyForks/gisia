# frozen_string_literal: true

class Dashboard::GroupsController < Dashboard::ApplicationController
  before_action :set_group, only: %i[edit update destroy]
  before_action :set_available_namespaces, only: %i[new create edit update]
  before_action :authorize_manage_group!, only: %i[edit update]
  before_action :authorize_destroy_group!, only: %i[destroy]

  def index
    @groups = current_user.groups.order(id: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.build_namespace unless @group.namespace
    @group.namespace.creator_id = current_user.id
    if @group.save
      redirect_to namespace_show_path(@group.namespace.full_path), notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def edit
    @group.namespace_parent_id = @group.namespace.parent_id
  end

  def update
    if @group.update(group_params)
      redirect_to namespace_show_path(@group.namespace.full_path), notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy!

    redirect_to dashboard_groups_path, status: :see_other, notice: 'Group was successfully destroyed.'
  end

  private

  def set_group
    @group = Group.find_by_full_path!(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :path, :namespace_parent_id, :description)
  end

  def set_available_namespaces
    @available_namespaces = available_namespaces_for_user
  end

  def available_namespaces_for_user
    current_user.groups.map(&:namespace)
  end

  def authorize_manage_group!
    return if current_user.admin?
    return if @group.members.with_user(current_user).with_at_least_access_level(Accessible::MAINTAINER).exists?

    redirect_to dashboard_groups_path, alert: 'You are not authorized to perform this action.'
  end

  def authorize_destroy_group!
    return if current_user.admin?
    return if @group.members.with_user(current_user).with_at_least_access_level(Accessible::OWNER).exists?

    redirect_to dashboard_groups_path, alert: 'You are not authorized to perform this action.'
  end
end
