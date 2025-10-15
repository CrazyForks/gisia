# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Users
  class Anonymous
    class << self
      def can?(action, subject = :global)
        Ability.allowed?(nil, action, subject)
      end
    end
  end
end
