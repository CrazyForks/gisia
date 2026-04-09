resources :personal_access_tokens, only: [:index, :show, :create] do
  member do
    post :rotate
    delete :revoke
  end
end
