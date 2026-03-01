# frozen_string_literal: true

module Ci
  module StuckBuilds
    class DropScheduledJob
      include ExclusiveLeaseGuard

      def perform
        try_obtain_lease do
          Ci::StuckBuilds::DropScheduledService.new.execute
        end
      end

      private

      def lease_timeout
        30.minutes
      end
    end
  end
end
