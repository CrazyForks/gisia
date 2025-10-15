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
    class Error
      include ActiveModel::Model
      include GlobalID::Identification

      attr_accessor :id, :title, :type, :user_count, :count,
        :first_seen, :last_seen, :message, :culprit,
        :external_url, :project_id, :project_name, :project_slug,
        :short_id, :status, :frequency

      def self.declarative_policy_class
        'ErrorTracking::BasePolicy'
      end
    end
  end
end
