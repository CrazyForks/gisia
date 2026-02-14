# frozen_string_literal: true

class Admin::ApplicationController < ApplicationController
  before_action :authenticate_admin!

  layout 'admin'

  private

  def authenticate_admin!
    head :forbidden unless current_user&.admin?
  end
end
