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
    module Traceable
      extend ActiveSupport::Concern
      extend MethodOverrideGuard

      TraceResult = Struct.new(:status, :stream_size, keyword_init: true)
      TraceRangeError = Class.new(StandardError)

      included do
        scope :with_live_trace, -> { where_exists(Ci::BuildTraceChunk.scoped_build) }
        scope :with_stale_live_trace, -> { with_live_trace.finished_before(12.hours.ago) }

        delegate :url, to: :runner_session, prefix: true, allow_nil: true
        delegate :enable_debug_trace!, to: :metadata
      end

      def trace
        Gitlab::Ci::Trace.new(self)
      end

      def append_trace(trace_input)
        @trace_input = trace_input

        # TODO:
        # it seems that `Content-Range` as formatted by runner is wrong,
        # the `byte_end` should point to final byte, but it points byte+1
        # that means that we have to calculate end of body,
        # as we cannot use `content_length[1]`
        # Issue: https://gitlab.com/gitlab-org/gitlab-runner/issues/3275

        content_range = trace_input.stream_range.split('-')
        body_start = content_range[0].to_i
        body_end = body_start + trace_input.body_data.bytesize

        if first_debug_chunk?(body_start)
          # Update the build metadata prior to appending trace content
          enable_debug_trace!
        end

        if trace_size_exceeded?(body_end)
          drop(:trace_size_exceeded)

          return TraceResult.new(status: 403)
        end

        stream_size = trace.append(trace_input.body_data, body_start)

        unless stream_size == body_end
          log_range_error(stream_size, body_end)

          return TraceResult.new(status: 416, stream_size: stream_size)
        end

        TraceResult.new(status: 202, stream_size: stream_size)
      end

      private

      def trace_input
        @trace_input
      end

      def first_debug_chunk?(body_start)
        body_start == 0 && trace_input.debug_trace
      end

      def log_range_error(stream_size, body_end)
        extra = {
          build_id: id,
          body_end: body_end,
          stream_size: stream_size,
          stream_class: stream_size.class,
          stream_range: trace_input.stream_range
        }

        trace_chunks.last.try do |chunk|
          extra.merge!(
            chunk_index: chunk.chunk_index,
            chunk_store: chunk.data_store,
            chunks_count: build.trace_chunks.count
          )
        end

        ::Gitlab::ErrorTracking
          .log_exception(TraceRangeError.new, extra)
      end

      def trace_size_exceeded?(_size)
        # Todo,
        false
        # project.actual_limits.exceeded?(:ci_jobs_trace_size_limit, size / 1.megabyte)
      end
    end
  end
end
