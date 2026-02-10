# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

constraints(::Constraints::ProjectUrlConstrainer.new) do
  scope(
    path: '*namespace_id',
    as: :namespace,
    namespace_id: Gitlab::PathRegex.full_namespace_route_regex
  ) do
    scope(
      path: ':project_id',
      constraints: { project_id: Gitlab::PathRegex.project_route_regex },
      module: :projects,
      as: :project
    ) do
      scope '-' do
        draw :repository
        draw :merge_requests
        draw :pipelines
        draw :jobs
        draw :issues
        draw :epics
        draw :boards

        # Notes routes
        resources :notes, only: [:show, :create, :edit, :update, :destroy] do
          member do
            post :replies
            post :resolve
            delete :resolve, action: :unresolve
            post :edit_form, action: :edit
            post :show_form, action: :show
          end
        end


        namespace :settings do
          resource :repository, only: [:edit, :update], controller: 'repository'
          resource :ci_cd, only: [:edit], controller: 'ci_cd'
          resource :pipelines, only: [:update], controller: 'pipelines'
          resources :variables, only: [:create, :update, :destroy], controller: 'variables'
          resources :protected_branches, only: [:index, :show, :create, :update, :destroy]
          resources :protected_tags, only: [:index, :show, :create, :update, :destroy]
          resources :labels, only: [:index, :create, :update, :destroy] do
            collection do
              post :new_form
            end
            member do
              post :edit_form
            end
          end
          resources :webhooks, only: [:index, :create, :update, :destroy] do
            collection do
              post :new_form
            end
            member do
              post :edit_form
            end
          end
        end
      end
    end
    resources(
      :projects,
      path: '/',
      constraints: { id: Gitlab::PathRegex.project_route_regex },
      only: %i[edit show update destroy]
    ) do
    end
  end
end
