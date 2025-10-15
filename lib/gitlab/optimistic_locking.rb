# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Gitlab
  module OptimisticLocking
    MAX_RETRIES = 100

    module_function

    def retry_lock(subject, max_retries = MAX_RETRIES, name:, &block)
      start_time = ::Gitlab::Metrics::System.monotonic_time
      retry_attempts = 0

      # prevent scope override, see https://gitlab.com/gitlab-org/gitlab/-/issues/391186
      klass = subject.is_a?(ActiveRecord::Relation) ? subject.klass : subject.class

      begin
        klass.transaction do
          yield(subject)
        end
      rescue ActiveRecord::StaleObjectError
        raise unless retry_attempts < max_retries

        subject.reset

        retry_attempts += 1
        retry
      ensure
        # Todo,
      end
    end

    alias_method :retry_optimistic_lock, :retry_lock
  end
end
