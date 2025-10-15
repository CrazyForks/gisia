# frozen_string_literal: true

class Admin::DashboardController < Admin::ApplicationController
  def index
    @users_count = User.count
    @projects_count = Project.count
    @groups_count = Namespace.where(type: 'Group').count
    @runners_count = Ci::Runner.count
    @pipelines_count = Ci::Pipeline.count
    @jobs_count = Ci::Build.count
  end
end