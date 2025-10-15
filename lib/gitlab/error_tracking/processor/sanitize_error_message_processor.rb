# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module ErrorTracking
    module Processor
      module SanitizeErrorMessageProcessor
        extend Gitlab::ErrorTracking::Processor::Concerns::ProcessesExceptions

        class << self
          def call(event)
            exceptions = extract_exceptions_from(event)

            exceptions.each do |exception|
              next unless valid_exception?(exception)

              message = Gitlab::Sanitizers::ExceptionMessage.clean(exception.type, exception.value)

              set_exception_message(exception, message)
            end

            event
          end
        end
      end
    end
  end
end
