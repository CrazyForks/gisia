class Dashboard::HomeController < Dashboard::ApplicationController
  def home
    if current_user.projects.exists?
      @projects = current_user.projects.order(id: :desc)
      render 'dashboard/projects/index'
    else
      @username = current_user.name
    end
  end
end
