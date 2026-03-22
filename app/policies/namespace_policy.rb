# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class NamespacePolicy < BasePolicy
  condition(:own_namespace) { @user.present? && @subject.owner == @user }

  rule { admin | own_namespace }.enable :admin_namespace
end

