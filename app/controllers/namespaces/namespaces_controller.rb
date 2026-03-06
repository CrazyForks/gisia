# frozen_string_literal: true

class Namespaces::NamespacesController < Namespaces::ApplicationController
  def show
    @is_owner = user_signed_in? && current_user == @namespace.creator
    projects = @namespace.descendant_projects
    projects = projects.joins(:namespace).where(namespaces: { visibility_level: Gitlab::VisibilityLevel::PUBLIC }) unless @is_owner
    @projects = projects.order(id: :desc)
  end
end
