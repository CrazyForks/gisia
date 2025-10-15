# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Git
  class Base
    include Gitlab::Utils::StrongMemoize

    attr_reader :project, :current_user, :params

    def initialize(project, user, params)
      @project = project
      @current_user = user
      @params = params
    end

    def push
      raise NotImplementedError
    end

    private

    def push_options
      strong_memoize(:push_options) do
        params[:push_options]&.deep_symbolize_keys
      end
    end
  end
end
