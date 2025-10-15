# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      class Normalizer
        class NumberStrategy
          class << self
            def applies_to?(config)
              config.is_a?(Integer) || (config.is_a?(Hash) && config.key?(:number))
            end

            def build_from(job_name, config)
              total = config.is_a?(Hash) ? config[:number] : config

              Array.new(total) do |index|
                new(job_name, index.next, total)
              end
            end
          end

          def initialize(job_name, instance, total)
            @job_name = job_name
            @instance = instance
            @total = total
          end

          def attributes
            {
              name: name,
              instance: instance,
              parallel: { total: total }
            }
          end

          def name
            "#{job_name} #{instance}/#{total}"
          end

          private

          attr_reader :job_name, :instance, :total
        end
      end
    end
  end
end
