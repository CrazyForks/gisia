# frozen_string_literal: true

class Projects::BranchesController < Projects::ApplicationController
  def index
    @branches = project.repository.local_branches.sort_by(&:name)
    
    if params[:search].present?
      search_term = params[:search].downcase
      @branches = @branches.select { |branch| branch.name.downcase.include?(search_term) }
    end
    
    @default_branch = project.default_branch
    @protected_branches = []
  end
end