# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

Rails.application.routes.draw do
  use_doorkeeper
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  mount MissionControl::Jobs::Engine, at: '/jobs' if Rails.env.development?

  devise_for :users, skip: [:registrations]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    resources :members
  end

  draw 'api/v4'

  root 'dashboard/home#home'
  scope path: '-' do
    namespace :dashboard do
      resources :projects, except: [:edit]
      resources :groups
    end

    draw 'users/settings'
  end

  draw :admin
  draw :project
  draw :git_http
end
