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
          class Base
            def evaluate(**variables)
              raise NotImplementedError
            end

            def name
              self.class.name.demodulize.underscore
            end

            def self.build(token)
              raise NotImplementedError
            end

            def self.scan(scanner)
              if scanner.scan(pattern)
                Expression::Token.new(scanner.matched, self)
              end
            end

            def self.pattern
              self::PATTERN
            end

            def self.consume?(lexeme)
              lexeme && precedence >= lexeme.precedence
            end
          end
        end
      end
    end
  end
end
