# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module RefComparable
  extend ActiveSupport::Concern

  def compare(base_sha: nil, straight: false)
    raw_compare = target_project.repository.compare_source_branch(target_branch_ref, source_project.repository,
      source_branch_ref, straight: straight)
    return unless raw_compare && raw_compare.base && raw_compare.head

    Compare.new(raw_compare, source_project, base_sha: base_sha, straight: straight)
  end

  def compare_commits
    compare.commits
  end

  def has_no_commits?
    !has_commits?
  end

  def commits_count
    if merge_request_diff.persisted?
      merge_request_diff.commits_count
    elsif compare_commits
      compare_commits.size
    else
      0
    end
  end

  def has_commits?
    merge_request_diff.persisted? && commits_count.to_i > 0
  end
end
