# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Users
  module CiTokenAuthenticatable
    extend ActiveSupport::Concern

    def ci_job_token_scope_cache_key
      "users:#{id}:ci:job_token_scope"
    end

    # This attribute hosts a Ci::JobToken::Scope object which is set when
    # the user is authenticated successfully via CI_JOB_TOKEN.
    def ci_job_token_scope
      Gitlab::SafeRequestStore[ci_job_token_scope_cache_key]
    end

    def from_ci_job_token?
      ci_job_token_scope.present?
    end
  end
end
