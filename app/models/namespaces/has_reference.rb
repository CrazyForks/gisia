# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Namespaces
  module HasReference
    extend ActiveSupport::Concern

    def to_reference_base(from = nil, full: false, absolute_path: false)
      return unless from

      full_path = "/#{full_path}" if absolute_path

      return full_path if full || user_ns?(from)
      return path if cross_project_reference?(from)

      full_path
    end

    def cross_project_reference?(from)
      return false if ns(from).project_namespace?

      ns(from).parent.id == id
    end

    private

    def ns(from)
      from.is_a?(Namespace) ? from : from.namespace
    end

    # Todo, add a wrapper from.is_user?
    def user_ns?(from)
      from.is_a?(User) || from.is_a?(Namespaces::UserNamespace)
    end
  end
end

