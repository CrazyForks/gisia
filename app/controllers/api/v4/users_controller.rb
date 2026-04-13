# frozen_string_literal: true

module API
  module V4
    class UsersController < ::API::V4::UserBaseController
      def index
        return forbidden! unless current_user.admin?

        users = User.all
        users = users.where(username: params[:username]) if params[:username].present?

        render json: users.select(:id, :username, :name, :email).map { |u|
          { id: u.id, username: u.username, name: u.name, email: u.email }
        }
      end

      def show
        render json: {
          id: current_user.id,
          username: current_user.username,
          name: current_user.name,
          email: current_user.email,
          state: current_user.state,
          locked: current_user.locked_at.present?,
          admin: current_user.admin?,
          created_at: current_user.created_at,
          confirmed_at: current_user.confirmed_at,
          last_sign_in_at: current_user.last_sign_in_at,
          current_sign_in_at: current_user.current_sign_in_at,
          namespace_id: current_user.namespace&.id,
          web_url: "#{Gitlab.config.gitlab.url}/#{current_user.username}"
        }
      end

      def create
        return forbidden! unless current_user.admin?

        user = User.new(create_user_params)
        user.skip_confirmation!

        if user.save
          render json: user_json(user), status: :created
        else
          render json: { message: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def create_user_params
        @create_user_params ||= params.permit(:email, :name, :username, :password, :admin)
      end

      def user_json(user)
        {
          id: user.id,
          username: user.username,
          name: user.name,
          email: user.email,
          state: user.state,
          admin: user.admin?,
          created_at: user.created_at,
          confirmed_at: user.confirmed_at,
          web_url: "#{Gitlab.config.gitlab.url}/#{user.username}"
        }
      end
    end
  end
end
