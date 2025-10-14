# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

Rails.application.configure do |config|
  config.middleware.insert_after RequestStore::Middleware, Gitlab::Middleware::RequestContext
end
