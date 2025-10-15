# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Sanitizers
    module ExceptionMessage
      FILTERED_STRING = '[FILTERED]'
      EXCEPTION_NAMES = %w[URI::InvalidURIError Addressable::URI::InvalidURIError].freeze
      MESSAGE_REGEX = %r{(\A[^:]+:\s).*\Z}

      class << self
        def clean(exception_name, message)
          return message unless exception_name.in?(EXCEPTION_NAMES)

          message.sub(MESSAGE_REGEX, '\1' + FILTERED_STRING)
        end
      end
    end
  end
end
