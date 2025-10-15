# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Middleware
    class RequestContext
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        Gitlab::RequestContext.start_request_context(request: request)
        Gitlab::RequestContext.start_thread_context

        @app.call(env)
      end
    end
  end
end
