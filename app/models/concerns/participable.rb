# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Participable
  extend ActiveSupport::Concern

  def participants(_user = nil)
    result = []
    result << author if respond_to?(:author)
    result += assignees.to_a if respond_to?(:assignees)
    result.compact.uniq
  end
end
