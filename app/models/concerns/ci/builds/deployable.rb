# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module Builds
    module Deployable
      extend ActiveSupport::Concern
      extend MethodOverrideGuard

      include Gitlab::Utils::StrongMemoize

      def expanded_environment_name; end

      def persisted_environment; end
    end
  end
end
