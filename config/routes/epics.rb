# frozen_string_literal: true

resources :epics, constraints: { id: /\d+/ } do
  collection do
    get :search_users
  end
  member do
    patch :close
    patch :reopen
    get :search_labels
    patch :link_labels
    delete :unlink_label
  end
end