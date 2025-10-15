# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::CommitController < Projects::ApplicationController
  before_action :commit
  before_action :set_commit_vars, only: [:show]

  def show; end

  private

  def commit
    @commit ||= @project.repository.commit_by(oid: params[:id])
  end

  def set_commit_vars
    return git_not_found! unless commit

    @diffs = @commit.diffs(commit_diff_options)
  end

  def commit_diff_options
    {}
  end
end

