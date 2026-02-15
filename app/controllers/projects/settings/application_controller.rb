# frozen_string_literal: true

class Projects::Settings::ApplicationController < Projects::ApplicationController
  before_action :authorize_settings_access!

  private

  def authorize_settings_access!
    return if current_user&.admin?
    return if @project.team.member?(current_user, Accessible::MAINTAINER)

    head :forbidden
  end
end
