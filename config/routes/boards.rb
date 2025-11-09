# frozen_string_literal: true

resources :boards, only: [:index] do
  resources :stages, only: [:create, :destroy] do
    member do
      post :edit_stage
      patch :update_stage
      patch :update_labels
      post :search_stage_labels
    end
  end
end
