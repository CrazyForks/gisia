# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module MergeRequests
  module Pipelines
    extend ActiveSupport::Concern
    include Gitlab::Utils::StrongMemoize

    COMMITS_LIMIT = 100

    def pipelines
      # Todo
      all
    end

    alias_method :all_pipelines, :pipelines

    private

    def all
      strong_memoize(:all_pipelines) do
        next Ci::Pipeline.none unless source_project

        pipelines =
          if merge_request.persisted?
            all_pipelines_for_merge_request
          else
            triggered_for_branch.for_sha(commit_shas)
          end

        sort(pipelines)
      end
    end

    def all_pipelines_for_merge_request
      pipelines_for_merge_request = triggered_by_merge_request
      pipelines_for_branch = triggered_for_branch.for_sha(recent_diff_head_shas(COMMITS_LIMIT))

      Ci::Pipeline.from_union([pipelines_for_merge_request, pipelines_for_branch])
    end

    def triggered_by_merge_request
      Ci::Pipeline.triggered_by_merge_request(merge_request)
    end

    def triggered_for_branch
      source_project.all_pipelines.ci_branch_sources.for_branch(source_branch)
    end

    def merge_request
      self
    end

    def sort(pipelines)
      pipelines_table = Ci::Pipeline.quoted_table_name
      sql = "CASE #{pipelines_table}.source WHEN (?) THEN 0 ELSE 1 END, #{pipelines_table}.id DESC"
      query = ApplicationRecord.send(:sanitize_sql_array, [sql, Ci::Pipeline.sources[:merge_request_event]])

      pipelines.order(Arel.sql(query))
    end
  end
end
