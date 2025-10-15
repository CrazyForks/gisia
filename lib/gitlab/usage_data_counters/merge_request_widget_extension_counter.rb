# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module UsageDataCounters
    class MergeRequestWidgetExtensionCounter < BaseCounter
      KNOWN_EVENTS = %w[view full_report_clicked expand expand_success expand_warning expand_failed].freeze
      PREFIX = 'i_code_review_merge_request_widget'
      WIDGETS = %w[
        accessibility
        code_quality
        license_compliance
        status_checks
        terraform
        test_summary
        metrics
        security_reports
      ].freeze

      class << self
        private

        def known_events
          self::WIDGETS.product(self::KNOWN_EVENTS).map { |name_parts| name_parts.join('_count_') }
        end
      end
    end
  end
end
