# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module API
  module V4
    module Internal
      class BaseController < ::API::V4::BaseController
        before_action :authenticate_by_gitlab_shell_token!

        private

        def authenticate_by_gitlab_shell_token!
          unauthorized! unless Gitlab::Shell.verify_api_request(request.headers)
        end
      end
    end
  end
end
