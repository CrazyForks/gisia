# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_user_stats, only: [:index]


  def index
    @users = User.includes(:projects, :groups).order(:id)

    @users = @users.ransack(name_i_cont: params[:search]).result(distinct: true) if params[:search].present?

    if params[:status].present?
      case params[:status]
      when 'active'
        @users = @users.active
      when 'admin'
        @users = @users.admins
      when 'pending'
        @users = @users.blocked_pending_approval
      end
    end

    @users = @users.page(params[:page]).per(20)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    update_params = user_params

    # Remove password fields if they're blank
    update_params = update_params.except(:password, :password_confirmation) if update_params[:password].blank?

    if @user.update(update_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :name, :admin, :password, :password_confirmation)
  end

  def set_user_stats
    all_users = User.all
    @users_count = all_users.count
    @pending_approval_count = all_users.confirmed.count
    @admin_count = all_users.admins.count
    @without_2fa_count = @users_count - @admin_count
  end
end
