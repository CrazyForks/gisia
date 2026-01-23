# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Git
  class Ref < Base
    def push
      changes = params[:changes]
      process_changes_by_action(changes.branch_changes)
    end

    private

    def group_changes_by_action(changes)
      changes.group_by do |change|
        change_action(change)
      end
    end

    def change_action(change)
      return :created if Gitlab::Git.blank_ref?(change[:oldrev])
      return :removed if Gitlab::Git.blank_ref?(change[:newrev])

      :pushed
    end

    def process_changes_by_action(changes)
      changes_by_action = group_changes_by_action(changes)

      changes_by_action.each do |action, changes|
        next unless changes.any?

        process_changes(action, changes,
          execute_project_hooks: execute_project_hooks?(changes))
      end
    end

    def ref_type(change)
      push = ::Gitlab::Git::Push.new(project, change[:oldrev], change[:newrev], change[:ref])

      if push.branch_push?
        :branch
      elsif push.tag_push?
        :tag
      end
    end

    def process_changes(_action, changes, execute_project_hooks:)
      changes.each do |change|
        ref_type = ref_type(change)
        next unless ref_type

        options = {
          change: change,
          push_options: params[:push_options]
        }
        push_service_class = push_service_class_for(ref_type)

        push_service_class.new(
          project,
          current_user,
          **options
        ).push
      end
    end

    def push_service_class_for(ref_type)
      return ::Git::Tag if ref_type == :tag

      ::Git::Branch
    end

    def execute_project_hooks?(_changes)
      false
    end
  end
end
