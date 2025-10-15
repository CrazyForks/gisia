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
      # Entry that represents a boolean value.
      #
      class Boolean < Node
        include Validatable

        validations do
          validates :config, boolean: true
        end
      end
    end
  end
end
