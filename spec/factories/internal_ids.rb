# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

FactoryBot.define do
  factory :internal_id do
    project
    usage { :issues }
    last_value { project.issues.maximum(:iid) || 0 }
  end

  trait :has_internal_id do
    after(:build) do |record|
      record.iid ||= generate(:iid)
    end
  end
end

