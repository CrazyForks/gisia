# frozen_string_literal: true

class Projects::SkillsController < Projects::ApplicationController
  include Gitlab::Auth::AuthFinders

  def project_skill
    render 'project', formats: [:text], content_type: 'text/markdown', layout: false
  end

  def issues
    render formats: [:text], content_type: 'text/markdown', layout: false
  end

  private

  def current_user
    @current_user ||= begin
      find_user_from_access_token
    rescue Gitlab::Auth::AuthenticationError
      nil
    end || super
  end

  def authenticate_unless_public!
    return if @project&.public?

    if request.headers['PRIVATE-TOKEN'].present?
      head :unauthorized unless current_user
    else
      authenticate_user!
    end
  end
end
