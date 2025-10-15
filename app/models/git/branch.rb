# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Git
  class Branch < Base
    include HasBranchHook
    include MergeRequests::Refreshable

    delegate :oldrev, :newrev, :ref, to: :change

    def push
      create_pipelines!
      refresh!
    end
  end
end
