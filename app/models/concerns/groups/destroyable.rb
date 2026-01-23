# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Groups
  module Destroyable
    extend ActiveSupport::Concern

    included do
      before_destroy :remove_all_descendant_projects
      before_destroy :remove_all_descendant_groups
      before_destroy :remove_namespace
    end

    private

    def remove_all_descendant_projects
      namespace.descendant_projects.destroy_all
    end

    def remove_all_descendant_groups
      namespace.descendant_groups.destroy_all
    end

    def remove_namespace
      namespace.destroy
    end
  end
end
