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
    class GeoController < ::API::V4::BaseController
      # Todo, add geo support
      def proxy
        render json: geo_proxy_response, status: :ok, content_type: content_type
      end

      private

      def content_type
        Gitlab::Workhorse::INTERNAL_API_CONTENT_TYPE
      end

      def geo_proxy_response
        { geo_enabled: false }
      end
    end
  end
end

