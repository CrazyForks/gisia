# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Namespaces
  class UserNamespace < Namespace
    def self.sti_name
      'User'
    end

    def default_branch_name; end

    def human_name
      creator_name
    end
  end
end
