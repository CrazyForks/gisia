# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================


module Gitlab
  module CurrentSettings
    class << self
      def disable_feed_token
        false
      end

      def enabled_git_access_protocol; end

      def receive_max_input_size; end

      def expire_current_application_settings; end

      def pick_repository_storage
        'default'
      end

      def gitlab_dedicated_instance?
        false
      end

      def admin_mode
        false
      end

      def ci_job_live_trace_enabled
        false
      end

      def allow_runner_registration_token
        true
      end

      def valid_runner_registrars
        %w[project group]
      end

      def runner_token_expiration_interval; end

      def ci_job_live_trace_enabled?
        false
      end

      def current_application_settings
        OpenStruct.new(
          current_application_settings: 55,
          gitaly_timeout_medium: 55,
          gitaly_timeout_fast: 10,
          plantuml_enabled?: false,
          ci_max_includes: 150,
          ci_max_total_yaml_size_bytes: 314_572_800,
          personal_access_token_prefix: 'glpat-',
          gitaly_timeout_default: 55,
          gitaly_timeout_fast: 10,
          gitaly_timeout_medium: 30
        )
      end

      def max_attachment_size
        OpenStruct.new(megabytes: 104_857_600)
      end

      def require_personal_access_token_expiry?
        true
      end

      def allowed_key_types
        Gitlab::SSHPublicKey.supported_types.select do |type|
          key_restriction_for(type) != FORBIDDEN_KEY_VALUE
        end
      end

      def key_restriction_for(_type)
        0
      end

      def hashed_storage_enabled
        true
      end

      def default_branch_name
        'main'
      end

      def diff_max_files
        1000
      end

      def diff_max_lines
        50_000
      end

      def diff_max_patch_bytes
        204_800
      end

      def custom_http_clone_url_root; end

    end
  end
end
