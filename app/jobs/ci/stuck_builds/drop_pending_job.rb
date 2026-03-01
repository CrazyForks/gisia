# frozen_string_literal: true

module Ci
  module StuckBuilds
    class DropPendingJob
      include ExclusiveLeaseGuard

      def perform
        try_obtain_lease do
          Ci::StuckBuilds::DropPendingService.new.execute
        end
      end

      private

      def lease_timeout
        30.minutes
      end
    end
  end
end
