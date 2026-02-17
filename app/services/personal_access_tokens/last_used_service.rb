# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module PersonalAccessTokens
  class LastUsedService
    LAST_USED_AT_TIMEOUT = 10.minutes

    def initialize(personal_access_token)
      @personal_access_token = personal_access_token
    end

    def execute
      return unless @personal_access_token.has_attribute?(:last_used_at)
      return unless last_used_at_needs_update?

      @personal_access_token.update_columns(last_used_at: Time.zone.now)
    end

    private

    def last_used_at_needs_update?
      last_used = @personal_access_token.last_used_at

      return true if last_used.nil?

      last_used <= LAST_USED_AT_TIMEOUT.ago
    end
  end
end
