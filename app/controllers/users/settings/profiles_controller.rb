module Users
  module Settings
    class ProfilesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_user

      def show; end

      def edit; end

      def update
        if @user.update(profile_params)
          redirect_to users_settings_profile_path, notice: 'Profile updated successfully.'
        else
          flash.now[:alert] = 'Failed to update profile.'
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = current_user
      end

      def profile_params
        params.require(:user).permit(:email, :username, :name, :mobile, :avatar)
      end
    end
  end
end
