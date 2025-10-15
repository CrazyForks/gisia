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
      class SshController < BaseController
        before_action :access_check!, only: [:allowed]

        def check
          # Todo,
          data = { api_version: 'v4', gitlab_version: '17.9.0-pre', gitlab_rev: '9771f39556e', redis: true }

          render json: data, status: :ok
        end

        def authorized_keys
          fingerprint = Gitlab::InsecureKeyFingerprint.new(params.expect(:key)).fingerprint_sha256

          key = Key.auth.find_by(fingerprint_sha256: fingerprint)

          if key.nil?
            render json: { error: 'Key not found' }, status: :not_found
          else
            render json: key, status: :ok
          end
        end

        def discover
          user = Key.auth.find_by_id(params.expect(:key_id))&.user

          if user
            render json: user.as_json(only: %i[id username name])
          else
            render json: { error: 'User not found' }, status: :not_found
          end
        end

        def allowed
          payload = accessor.payload

          receive_max_input_size = Gitlab::CurrentSettings.receive_max_input_size.to_i

          if receive_max_input_size > 0
            payload[:git_config_options] << "receive.maxInputSize=#{receive_max_input_size.megabytes}"
          end

          render json: payload, status: :ok
        end

        def pre_receive
          reference_counter_increased = Gitlab::ReferenceCounter.new(params[:gl_repository]).increase

          render json: { reference_counter_increased: reference_counter_increased }, status: :ok
        end

        def post_receive
          render json: accessor.post_receive, status: :ok
        end

        private

        def access_check!
          accessor.check!
        end

        def accessor
          @access_checker ||= Ssh::Accessor.new(ssh_params)
        end

        def ssh_params
          # todo, permit
          @ssh_params ||= params.require('ssh')
        end
      end
    end
  end
end
