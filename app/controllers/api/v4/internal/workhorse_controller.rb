# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module API
  module V4
    module Internal
      class WorkhorseController < ApplicationController
        include WorkhorseRequest
        include WorkhorseHelper

        before_action :verify_workhorse_api!
        before_action :set_workhorse_internal_api_content_type
        skip_before_action :verify_authenticity_token

        def authorize_upload
          unless request_authenticated?
            head :unauthorized
            return
          end

          render json: { TempPath: File.join(::Gitlab.config.uploads.storage_path, 'uploads/tmp') }, status: :ok
        end

        private

        def request_authenticated?
          authenticator = Gitlab::Auth::RequestAuthenticator.new(request)
          return true if authenticator.find_authenticated_requester([:api])

          # Look up user from warden, ignoring the absence of a CSRF token. For
          # web users the CSRF token can be in the POST form data but Workhorse
          # does not propagate the form data to us.
          !!request.env['warden']&.authenticate
        end
      end
    end
  end
end
