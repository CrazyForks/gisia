# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module SidekiqMiddleware
    # Sidekiq retry error that won't be reported to Sentry
    # Use it when a job retry is an expected behavior
    RetryError = Class.new(StandardError)
  end
end
