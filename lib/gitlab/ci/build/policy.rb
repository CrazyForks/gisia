# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      module Policy
        def self.fabricate(specs)
          specifications = specs.to_h.map do |spec, value|
            self.const_get(spec.to_s.camelize, false).new(value)
          end

          specifications.compact
        end
      end
    end
  end
end
