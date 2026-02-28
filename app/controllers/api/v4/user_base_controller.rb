# frozen_string_literal: true

module API
  module V4
    class UserBaseController < ::API::V4::BaseController
      include API::V4::TokenAuthenticatable
      include API::V4::Paginatable

      before_action :authenticate!
    end
  end
end
