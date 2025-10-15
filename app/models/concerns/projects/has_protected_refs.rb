# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Projects
  module HasProtectedRefs
    extend ActiveSupport::Concern
    include Gitlab::Utils::StrongMemoize

    def allow_push?(user, name)
      protected_branches.push.allowed? max_access(user), name
    end

    def allow_force_push?(user, name)
      protected_branches.force_push.allowed? max_access(user), name
    end

    def allow_merge_to?(user, name)
      protected_branches.merge_to.allowed? max_access(user), name
    end

    def allow_create(user, name)
      protected_tags.push.allowed? max_access(user), name
    end

    private

    def max_access(user)
      strong_memoize_with(:max_access, user.id) do
        user.max_access(self)
      end
    end
  end
end
