# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module MergeRequests
  module Variables
    def predefined_variables
      Gitlab::Ci::Variables::Collection.new.tap do |variables|
        variables.append(key: 'CI_MERGE_REQUEST_ID', value: id.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_IID', value: iid.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_REF_PATH', value: ref_path.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_PROJECT_ID', value: project.id.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_PROJECT_PATH', value: project.full_path)
        variables.append(key: 'CI_MERGE_REQUEST_PROJECT_URL', value: project.web_url)
        variables.append(key: 'CI_MERGE_REQUEST_TARGET_BRANCH_NAME', value: target_branch.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_TARGET_BRANCH_PROTECTED',
          value: false.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_TITLE', value: title)
        # variables.append(key: 'CI_MERGE_REQUEST_DRAFT', value: work_in_progress?.to_s)

        # mr_description, mr_description_truncated = truncate_mr_description
        # variables.append(key: 'CI_MERGE_REQUEST_DESCRIPTION', value: mr_description)
        # variables.append(key: 'CI_MERGE_REQUEST_DESCRIPTION_IS_TRUNCATED', value: mr_description_truncated)
        variables.append(key: 'CI_MERGE_REQUEST_ASSIGNEES', value: assignee_username_list) if assignees.present?
        # variables.append(key: 'CI_MERGE_REQUEST_MILESTONE', value: milestone.title) if milestone
        # variables.append(key: 'CI_MERGE_REQUEST_LABELS', value: label_names.join(',')) if labels.present?
        variables.append(key: 'CI_MERGE_REQUEST_SQUASH_ON_MERGE', value: false.to_s)
        variables.concat(source_project_variables)
      end
    end

    def source_project_variables
      Gitlab::Ci::Variables::Collection.new.tap do |variables|
        break variables unless source_project

        variables.append(key: 'CI_MERGE_REQUEST_SOURCE_PROJECT_ID', value: source_project.id.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_SOURCE_PROJECT_PATH', value: source_project.full_path)
        variables.append(key: 'CI_MERGE_REQUEST_SOURCE_PROJECT_URL', value: source_project.web_url)
        variables.append(key: 'CI_MERGE_REQUEST_SOURCE_BRANCH_NAME', value: source_branch.to_s)
        variables.append(key: 'CI_MERGE_REQUEST_SOURCE_BRANCH_PROTECTED',
          value: false.to_s)
      end
    end
  end
end
