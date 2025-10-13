resources :jobs, only: %i[create update] do
  collection do
    post :request, action: :job_request
  end

  member do
    patch :trace
  end
end

