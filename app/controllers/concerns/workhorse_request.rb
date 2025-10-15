# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module WorkhorseRequest
  extend ActiveSupport::Concern

  included do
    before_action :verify_workhorse_api!
  end

  private

  def verify_workhorse_api!
    Gitlab::Workhorse.verify_api_request!(request.headers)
  end
end
