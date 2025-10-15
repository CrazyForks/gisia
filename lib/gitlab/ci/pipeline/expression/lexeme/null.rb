# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Pipeline
      module Expression
        module Lexeme
          class Null < Lexeme::Value
            PATTERN = /null/

            def initialize(value = nil)
              super
            end

            def evaluate(variables = {})
              nil
            end

            def inspect
              'null'
            end

            def self.build(_value)
              self.new
            end
          end
        end
      end
    end
  end
end
