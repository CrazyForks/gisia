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
          class Value < Lexeme::Base
            def self.type
              :value
            end

            attr_reader :value

            def initialize(value)
              @value = value
            end
          end
        end
      end
    end
  end
end
