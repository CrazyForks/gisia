# frozen_string_literal: true

resources :boards, only: [:index] do
  resources :stages, only: [] do
    member do
      post :edit_stage
      patch :update_stage
      post :search_stage_labels
    end
  end
end
