namespace :users do
  namespace :settings do
    resource :profile, only: %i[show edit update]
    resources :keys
  end
end

