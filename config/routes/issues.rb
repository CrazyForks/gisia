# frozen_string_literal: true

resources :issues, constraints: { id: /\d+/ } do
  collection do
    get :search_users
  end
  member do
    patch :close
    patch :reopen
    post :move_stage
    patch :link_labels
    delete :unlink_label
    get :search_labels
  end
end