# frozen_string_literal: true

module API
  module V4
    class ProjectBaseController < ::API::V4::UserBaseController
      include API::V4::ProjectFindable

      before_action :find_project!
    end
  end
end
