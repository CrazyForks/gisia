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
    class RunnersController < ::API::V4::CiBaseController
      before_action :authenticate_runner!, :set_runner, only: [:verify]

      JOB_TOKEN_HEADER = 'HTTP_JOB_TOKEN'
      JOB_TOKEN_PARAM = :token

      def create
        @runner = Ci::Runner.new create_params
        @runner.register!

        render :create, status: :created
      end

      def verify; end

      private

      def set_runner
        @runner = current_runner
      end

      def verify_params
        params.permit(
          :system_id
        ).merge token
      end

      def active
        params.key?(:paused) ? !params[:paused] : !!params[:active]
      end

      def note
        params.fetch(:maintainer_note, nil) || params[:maintenance_note]
      end

      def name
        params.dig(:info, :name)
      end

      def create_params
        params.permit(
          :description,
          :locked,
          :access_level,
          :run_untagged,
          :maximum_timeout,
          tag_list: []
        ).merge(active: active, maintainer_note: note, registration_token: token, name: name)
      end

    end
  end
end
