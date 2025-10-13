resources :runners, only: %i[create] do
  collection do
    post :verify
  end
end
