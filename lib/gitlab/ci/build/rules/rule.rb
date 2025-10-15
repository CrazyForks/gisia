# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      class Rules::Rule
        attr_accessor :attributes

        def self.fabricate_list(list)
          list.map(&method(:new)) if list
        end

        def initialize(spec)
          @clauses    = []
          @attributes = {}

          spec.each do |type, value|
            if clause = Clause.fabricate(type, value)
              @clauses << clause
            else
              @attributes.merge!(type => value)
            end
          end
        end

        def matches?(pipeline, context)
          @clauses.all? { |clause| clause.satisfied_by?(pipeline, context) }
        end
      end
    end
  end
end
