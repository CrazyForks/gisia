# frozen_string_literal: true

resources :epics, constraints: { id: /\d+/ } do
  collection do
    get :search_users
  end
  member do
    patch :close
    patch :reopen
  end
end