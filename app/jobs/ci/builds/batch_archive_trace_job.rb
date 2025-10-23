# frozen_string_literal: true

module Ci
  module Builds
    class BatchArchiveTraceJob < ApplicationJob
      retry_on StandardError, wait: :polynomially_longer, attempts: 2

      def perform
        Ci::Build.batch_archive_traces!
      end
    end
  end
end
