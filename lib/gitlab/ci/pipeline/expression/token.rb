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
        class Token
          attr_reader :value, :lexeme

          def initialize(value, lexeme)
            @value = value
            @lexeme = lexeme
          end

          def build(*args)
            @lexeme.build(@value, *args)
          end

          def type
            @lexeme.type
          end

          def to_lexeme
            @lexeme.name.demodulize.downcase
          end
        end
      end
    end
  end
end
