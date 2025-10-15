# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module ErrorTracking
    class Logger < ::Gitlab::JsonLogger
      def self.capture_exception(exception, **context_payload)
        formatter = Gitlab::ErrorTracking::LogFormatter.new
        log_hash = formatter.generate_log(exception, context_payload)

        self.error(log_hash)
      end

      def self.file_name_noext
        'exceptions_json'
      end
    end
  end
end
