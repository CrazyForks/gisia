# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

resources :merge_requests, except: [:destroy], constraints: { id: /\d+/ } do
  collection do
    get :search_users
  end
  member do
    get :show
    get :commits
    get :diffs
    get :pipelines
    post :merge
    post :close
  end

  resources :diff_notes, only: [:create]
end
