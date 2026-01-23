# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module Builds
    module Processable
      extend ActiveSupport::Concern
      include Gitlab::Utils::StrongMemoize

      def prosess!(current_status)
        skip and return false unless valid_statuses.include?(current_status)

        return enqueue if enqueue_immediately?
        return schedule if schedulable?
        return actionize if action?

        enqueue
      end

      def schedulable?
        self.when == 'delayed' && options[:start_in].present?
      end

      def action?
        ::Ci::Processable::ACTIONABLE_WHEN.include?(self.when)
      end

      def cancelable?
        (active? || created?) && !canceling?
      end

      def force_cancelable?
        canceling? && supports_force_cancel?
      end

      private

      def valid_statuses
        case self.when
        when 'on_success', 'manual', 'delayed'
          scheduling_type_dag? ? %w[success] : %w[success skipped]
        when 'on_failure'
          %w[failed]
        when 'always'
          %w[success failed skipped]
        else
          []
        end
      end
    end
  end
end
