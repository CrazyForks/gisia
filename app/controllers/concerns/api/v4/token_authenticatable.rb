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
    module TokenAuthenticatable
      extend ActiveSupport::Concern

      included do
        include Gitlab::Auth::AuthFinders
      end

      private

      def current_user
        @current_user ||= find_user_from_access_token
      rescue Gitlab::Auth::AuthenticationError
        nil
      end

      def authenticate!
        unauthorized! if current_user.nil?
      end
    end
  end
end
