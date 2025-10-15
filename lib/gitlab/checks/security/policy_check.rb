# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Checks
    module Security
      class PolicyCheck < BaseSingleChecker
        def validate!; end
      end
    end
  end
end

Gitlab::Checks::Security::PolicyCheck.prepend_mod
