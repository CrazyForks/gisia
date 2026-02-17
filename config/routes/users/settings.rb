namespace :users do
  namespace :settings do
    resource :profile, only: %i[show edit update]
    resource :password, only: %i[edit update]
    resources :keys
    resources :personal_access_tokens, only: %i[index new create] do
      member do
        put :revoke
      end
    end
  end
end

