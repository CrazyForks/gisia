# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module ErrorTracking
    module Processor
      module Concerns
        module ProcessesExceptions
          private

          def extract_exceptions_from(event)
            exceptions = event&.exception&.instance_variable_get(:@values)

            Array.wrap(exceptions)
          end

          def set_exception_message(exception, message)
            if exception.respond_to?(:value=)
              exception.value = message
            else
              exception.instance_variable_set(:@value, message)
            end
          end

          def valid_exception?(exception)
            case exception
            when Sentry::SingleExceptionInterface
              exception&.value.present?
            else
              false
            end
          end
        end
      end
    end
  end
end
