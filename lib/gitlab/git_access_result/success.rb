# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitAccessResult
    class Success
      attr_reader :console_messages

      def initialize(console_messages: [])
        @console_messages = console_messages
      end
    end
  end
end
