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
      # This class represents an unspecified entry.
      #
      # It decorates original entry adding method that indicates it is
      # unspecified.
      #
      class Unspecified < SimpleDelegator
        def specified?
          false
        end
      end
    end
  end
end
