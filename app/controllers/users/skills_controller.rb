# frozen_string_literal: true

class Users::SkillsController < ApplicationController
  include Gitlab::Auth::AuthFinders

  def show
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

  def authenticate_user!
    return if current_user

    if request.headers['PRIVATE-TOKEN'].present?
      head :unauthorized
    else
      super
    end
  end
end
