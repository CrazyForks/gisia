# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# This should be in the ErrorTracking namespace. For more details, see:
# https://gitlab.com/gitlab-org/gitlab/-/issues/323342
module Gitlab
  module ErrorTracking
    class ErrorEvent
      include ActiveModel::Model

      attr_accessor :issue_id, :date_received, :stack_trace_entries, :gitlab_project, :project_id

      def self.declarative_policy_class
        'ErrorTracking::BasePolicy'
      end
    end
  end
end
