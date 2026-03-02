# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V4::Users', type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:token) { create(:personal_access_token, user: user) }

  let(:auth_headers) { { 'PRIVATE-TOKEN' => token.token, 'Accept' => 'application/json' } }

  describe 'GET /api/v4/user' do
    it 'returns 401 when token is missing' do
      get '/api/v4/user'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 when token is invalid' do
      get '/api/v4/user', headers: { 'PRIVATE-TOKEN' => 'invalid-token' }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the current user with basic fields' do
      get '/api/v4/user', headers: auth_headers

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['id']).to eq(user.id)
      expect(body['username']).to eq(user.username)
      expect(body['name']).to eq(user.name)
      expect(body['email']).to eq(user.email)
      expect(body['state']).to eq(user.state)
      expect(body).to include('locked', 'admin', 'created_at', 'confirmed_at',
                              'last_sign_in_at', 'current_sign_in_at', 'web_url')
    end
  end
end
