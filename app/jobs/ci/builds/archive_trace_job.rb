# frozen_string_literal: true

module Ci
  module Builds
    class ArchiveTraceJob < ApplicationJob
      retry_on StandardError, wait: :polynomially_longer, attempts: 3

      def perform(job_id)
        return unless build = Ci::Build.find_by_id(job_id)

        build.archive_trace!
      end
    end
  end
end
