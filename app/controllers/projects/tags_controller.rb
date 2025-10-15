# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::TagsController < Projects::ApplicationController
  def index
    @tags = project.repository.tags.sort_by { |tag| tag.dereferenced_target&.committed_date || Time.at(0) }.reverse
    
    if params[:search].present?
      search_term = params[:search].downcase
      @tags = @tags.select { |tag| tag.name.downcase.include?(search_term) }
    end
    
    @releases = []
  end
end