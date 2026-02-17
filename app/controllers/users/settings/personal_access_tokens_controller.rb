# frozen_string_literal: true

module Users
  module Settings
    class PersonalAccessTokensController < ApplicationController
      before_action :authenticate_user!

      def index
        @tokens = current_user.personal_access_tokens.order(created_at: :desc)
        @new_token = flash[:new_token]
      end

      def new
        @token = PersonalAccessToken.new(expires_at: 30.days.from_now)
      end

      def create
        @token = current_user.personal_access_tokens.build(token_params)
        @token.scopes = params[:personal_access_token][:scopes]&.reject(&:blank?) || []

        if @token.save
          flash[:new_token] = @token.token
          redirect_to users_settings_personal_access_tokens_path, notice: "Personal access token \"#{@token.name}\" created successfully."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def revoke
        @token = current_user.personal_access_tokens.find(params[:id])
        @token.revoke!
        redirect_to users_settings_personal_access_tokens_path, notice: "Revoked personal access token \"#{@token.name}\"."
      end

      private

      def token_params
        params.require(:personal_access_token).permit(:name, :expires_at, :description)
      end
    end
  end
end
