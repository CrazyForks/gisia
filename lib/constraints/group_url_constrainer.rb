# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Constraints
  class GroupUrlConstrainer
    def matches?(request)
      full_path = request.params[:namespace_id]

      return false unless NamespacePathValidator.valid_path?(full_path)

      Group.find_by_full_path(full_path, follow_redirects: request.get?).present?
    end
  end
end

