# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      class Rules::Rule::Clause
        ##
        # Abstract class that defines an interface of a single
        # job rule specification.
        #
        # Used for job's inclusion rules configuration.
        #
        UnknownClauseError = Class.new(StandardError)
        ParseError = Class.new(StandardError)

        def self.fabricate(type, value)
          "#{self}::#{type.to_s.camelize}".safe_constantize&.new(value)
        end

        def initialize(spec)
          @spec = spec
        end

        def satisfied_by?(pipeline, context = nil)
          raise NotImplementedError
        end
      end
    end
  end
end
