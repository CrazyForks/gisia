# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

scope format: false do
  scope constraints: { id: Gitlab::PathRegex.git_reference_regex } do
    resources :branches, only: [:index]
    resources :tags, only: [:index]
  end

  scope constraints: { id: /[^\0]+/ } do
    scope controller: :blob do
      get '/new/*id', action: :new, as: :new_blob
      post '/create/*id', action: :create, as: :create_blob
      get '/edit/*id', action: :edit, as: :edit_blob
      put '/update/*id', action: :update, as: :update_blob
      post '/preview/*id', action: :preview, as: :preview_blob

      scope path: '/blob/*id', as: :blob do
        get :diff
        get :diff_lines
        get '/', action: :show
        delete '/', action: :destroy
        post '/', action: :create
        put '/', action: :update
      end
    end

    get '/tree/*id', to: 'tree#show', as: :tree
    get '/raw/*id', to: 'raw#show', as: :raw

    get '/commits/*id', to: 'commits#show', as: :commits
  end
end

resources :commit, only: [:show], constraints: { id: Gitlab::Git::Commit::SHA_PATTERN } do
  member do
    get :show, to: 'commit#show', constraints: ->(params) { params[:rapid_diffs] == 'true' }
  end
end
