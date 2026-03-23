# frozen_string_literal: true

module API
  module V4
    class UsersController < ::API::V4::UserBaseController
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
    end
  end
end
