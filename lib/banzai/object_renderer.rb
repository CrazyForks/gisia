# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================


module Banzai
  class ObjectRenderer
    def initialize(default_project: nil, user: nil, redaction_context: {}); end

    def render(_items, _method = nil)
      'rendered'
    end
  end
end
