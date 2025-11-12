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
  sequence(:username) { |n| "user#{n}" }
  sequence(:name) { |n| "Fname Lname#{n}" }
  sequence(:email) { |n| "user#{n}@example.org" }
  sequence(:title) { |n| "My title #{n}" }
  sequence(:filename) { |n| "filename-#{n}.rb" }
  sequence(:label_title) { |n| "label#{n}" }
  sequence(:branch) { |n| "my-branch-#{n}" }
  sequence(:iid, 2)
  sequence(:sha) { |n| Digest::SHA1.hexdigest("commit-like-#{n}") }
end
