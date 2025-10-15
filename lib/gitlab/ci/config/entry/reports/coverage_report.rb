# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module Entry
        class Reports
          class CoverageReport < ::Gitlab::Config::Entry::Node
            include ::Gitlab::Config::Entry::Validatable
            include ::Gitlab::Config::Entry::Attributable

            ALLOWED_KEYS = %i[coverage_format path].freeze
            SUPPORTED_COVERAGE = %w[cobertura jacoco].freeze

            attributes ALLOWED_KEYS

            validations do
              validates :config, type: Hash
              validates :config, allowed_keys: ALLOWED_KEYS

              with_options(presence: true) do
                validates :coverage_format, inclusion: { in: SUPPORTED_COVERAGE, message: "must be one of supported formats: #{SUPPORTED_COVERAGE.join(', ')}." }
                validates :path, type: String
              end
            end
          end
        end
      end
    end
  end
end
