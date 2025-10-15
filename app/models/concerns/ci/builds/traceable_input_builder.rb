# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module Builds
    class TraceableInputBuilder
      attr_reader :debug_trace, :stream_range, :body_data

      def self.from(params, headers, body)
        new(
          debug_trace: Gitlab::Utils.to_boolean(params[:debug_trace]),
          stream_range: headers['Content-Range'],
          body_data: body.read
        )
      end

      def initialize(debug_trace:, stream_range:, body_data:)
        @debug_trace = debug_trace
        @stream_range = stream_range
        @body_data = body_data
      end
    end
  end
end

