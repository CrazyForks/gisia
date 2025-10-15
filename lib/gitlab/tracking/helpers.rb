# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Tracking
    module Helpers
      def dnt_enabled?
        Gitlab::Utils.to_boolean(request.headers['DNT'])
      end

      def trackable_html_request?
        request.format.html? && !dnt_enabled?
      end
    end
  end
end
