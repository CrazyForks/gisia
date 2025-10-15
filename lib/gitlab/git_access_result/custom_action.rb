# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitAccessResult
    class CustomAction
      attr_reader :payload, :console_messages

      # Example of payload:
      #
      # {
      #   'action' => 'geo_proxy_to_primary',
      #   'data' => {
      #     'api_endpoints' => %w{geo/proxy_git_ssh/info_refs_receive_pack geo/proxy_git_ssh/receive_pack},
      #     'gl_username' => user.username,
      #     'primary_repo' => geo_primary_http_url_to_repo(container)
      #   }
      # }
      #
      def initialize(payload, console_messages)
        @payload = payload
        @console_messages = console_messages
      end
    end
  end
end
