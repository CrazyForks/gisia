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
  module Buildable
    extend ActiveSupport::Concern

    class_methods do
      def build_from(project, user, params,event, options)
        Ci::PipelineBuilder.new(project, user, params).build!(event, **options)
      end
    end
  end
end
