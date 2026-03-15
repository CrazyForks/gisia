resources :projects, only: [] do
  resources :issues, only: [:index, :show, :create, :update, :destroy], param: :issue_iid, controller: 'projects/issues'
  resources :labels, only: [:index, :show, :create, :update, :destroy], controller: 'projects/labels'
  resources :epics, only: [:index, :show, :create, :update, :destroy], param: :epic_iid, controller: 'projects/epics' do
    member do
      get :issues, controller: 'projects/epic_issues', action: :index
    end
  end
  resources :merge_requests, only: [:index, :show, :create, :update, :destroy],
    param: :merge_request_iid, controller: 'projects/merge_requests'
end
