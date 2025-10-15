# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Config
    module Entry
      ##
      # This class represents an undefined entry.
      #
      class Undefined < Node
        def initialize(*)
          super(nil)
        end

        def value
          nil
        end

        def valid?
          true
        end

        def errors
          []
        end

        def specified?
          false
        end

        def relevant?
          false
        end

        def type
          nil
        end

        def inspect
          "#<#{self.class.name}>"
        end
      end
    end
  end
end
