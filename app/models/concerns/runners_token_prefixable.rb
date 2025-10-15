# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module RunnersTokenPrefixable
  # Prefix for runners_token which can be used to invalidate existing tokens.
  # The value chosen here is GR (for Gitlab Runner) combined with the rotation
  # date (20220225) decimal to hex encoded.
  RUNNERS_TOKEN_PREFIX = 'GR1348941'
end
