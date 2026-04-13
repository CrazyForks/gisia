class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  around_action :set_locale

  private

  def set_locale(&block)
    if current_user
      Gitlab::I18n.with_user_locale(current_user, &block)
    else
      Gitlab::I18n.with_default_locale(&block)
    end
  end

  def permitted_param(key)
    params.permit(key)[key]
  end
end
