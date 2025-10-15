# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module External
        class Mapper
          # Filters locations according to rules
          class Filter < Base
            private

            def process_without_instrumentation(locations)
              locations.select do |location|
                Rules.new(location[:rules]).evaluate(context).pass?
              end
            end
          end
        end
      end
    end
  end
end
