resources :projects, only: [] do
  resources :issues, only: [:index, :show, :create, :update, :destroy], param: :issue_iid, controller: 'projects/issues'
  resources :labels, only: [:index, :show, :create, :update, :destroy], controller: 'projects/labels'
end
