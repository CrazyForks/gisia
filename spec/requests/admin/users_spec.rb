require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  include Devise::Test::IntegrationHelpers

  let_it_be(:admin) { create(:user, admin: true) }
  let_it_be(:non_admin) { create(:user) }

  describe 'GET /admin/users' do
    context 'when user is not an admin' do
      before { sign_in non_admin }

      it 'returns 403 forbidden' do
        get admin_users_path

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is an admin' do
      before { sign_in admin }

      it 'returns 200 ok' do
        get admin_users_path

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
