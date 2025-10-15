# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Auth
    class KeyStatusChecker
      include Gitlab::Utils::StrongMemoize

      attr_reader :key

      def initialize(key)
        @key = key
      end

      def show_console_message?
        console_message.present?
      end

      def console_message
        strong_memoize(:console_message) do
          if key.expired?
            _('INFO: Your SSH key has expired. Please generate a new key.')
          elsif key.expires_soon?
            _('INFO: Your SSH key is expiring soon. Please generate a new key.')
          end
        end
      end
    end
  end
end
