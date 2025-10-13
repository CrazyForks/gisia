# config/routes/api_internal.rb

namespace :internal do
  scope module: :ssh do
    get 'check'
    get 'authorized_keys'
    get 'discover'
    post 'allowed'
    post 'pre_receive'
    post 'post_receive'
  end

  namespace :workhorse do
    post 'authorize_upload'
  end
end
