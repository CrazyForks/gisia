module Users
  module Settings
    class PasswordsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_user

      def edit; end

      def update
        if @user.update_with_password(password_params)
          redirect_to users_settings_profile_path, notice: 'Password changed successfully.'
        else
          flash.now[:alert] = 'Failed to change password.'
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = current_user
      end

      def password_params
        params.require(:user).permit(:current_password, :password, :password_confirmation)
      end
    end
  end
end
