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
  module Runners
    module HasVariables
      def predefined_variables
        Gitlab::Ci::Variables::Collection.new
                                         .append(key: 'CI_RUNNER_ID', value: id.to_s)
                                         .append(key: 'CI_RUNNER_DESCRIPTION', value: description)
                                         .append(key: 'CI_RUNNER_TAGS', value: tag_list.to_a.to_s)
      end
    end
  end
end
