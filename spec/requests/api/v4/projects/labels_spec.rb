# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V4::Projects::Labels', type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:token) { create(:personal_access_token, user: user) }
  let_it_be(:project) { create(:project, creator: user) }

  let(:auth_headers) { { 'PRIVATE-TOKEN' => token.token, 'Accept' => 'application/json' } }

  describe 'Project not found' do
    it 'returns 401 without authentication' do
      get '/api/v4/projects/0/labels'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 404 for unknown project id' do
      get '/api/v4/projects/0/labels', headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /api/v4/projects/:id/labels' do
    let_it_be(:label1) { create(:label, title: 'Alpha', namespace: project.namespace) }
    let_it_be(:label2) { create(:label, title: 'Zebra', namespace: project.namespace) }
    let_it_be(:other_project) { create(:project, creator: user) }
    let_it_be(:other_label) { create(:label, namespace: other_project.namespace) }

    it 'returns only labels belonging to the project, ordered by title' do
      get "/api/v4/projects/#{project.id}/labels", headers: auth_headers

      expect(response).to have_http_status(:ok)
      titles = json_response.map { |l| l['name'] }
      expect(titles).to include('Alpha', 'Zebra')
      expect(titles).not_to include(other_label.title)
      expect(titles).to eq(titles.sort)
    end

    it 'filters labels by search param' do
      get "/api/v4/projects/#{project.id}/labels", params: { search: 'alp' }, headers: auth_headers

      expect(response).to have_http_status(:ok)
      titles = json_response.map { |l| l['name'] }
      expect(titles).to include('Alpha')
      expect(titles).not_to include('Zebra')
    end
  end

  describe 'GET /api/v4/projects/:id/labels/:id' do
    let_it_be(:label) { create(:label, namespace: project.namespace) }
    let_it_be(:other_project) { create(:project, creator: user) }
    let_it_be(:other_label) { create(:label, namespace: other_project.namespace) }

    it 'returns the correct label with all required fields' do
      get "/api/v4/projects/#{project.id}/labels/#{label.id}", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response).to include(
        'id' => label.id,
        'name' => label.title,
        'color' => label.color,
        'description' => label.description
      )
      expect(json_response['created_at']).to be_present
      expect(json_response['updated_at']).to be_present
    end

    it 'returns 404 for a label from another project' do
      get "/api/v4/projects/#{project.id}/labels/#{other_label.id}", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v4/projects/:id/labels' do
    it 'creates a label and returns 201' do
      post "/api/v4/projects/#{project.id}/labels",
        params: { title: 'New Label', color: '#FF0000' },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['name']).to eq('New Label')
      expect(json_response['color']).to eq('#FF0000')
    end

    it 'creates a label with description' do
      post "/api/v4/projects/#{project.id}/labels",
        params: { title: 'With Desc', color: '#00FF00', description: 'A desc' },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['description']).to eq('A desc')
    end

    it 'returns 422 when title is missing' do
      post "/api/v4/projects/#{project.id}/labels",
        params: { color: '#FF0000' },
        headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['message']).to be_present
    end

    it 'returns 422 when color is missing' do
      post "/api/v4/projects/#{project.id}/labels",
        params: { title: 'No Color' },
        headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['message']).to be_present
    end
  end

  describe 'PUT /api/v4/projects/:id/labels/:id' do
    let!(:label) { create(:label, namespace: project.namespace) }

    it 'updates the label and returns 200' do
      put "/api/v4/projects/#{project.id}/labels/#{label.id}",
        params: { title: 'Updated', color: '#123456' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['name']).to eq('Updated')
      expect(json_response['color']).to eq('#123456')
    end

    it 'returns 404 for unknown label' do
      put "/api/v4/projects/#{project.id}/labels/99999",
        params: { title: 'x' },
        headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v4/projects/:id/labels/:id' do
    let!(:label) { create(:label, namespace: project.namespace) }

    it 'returns 204 and removes the label' do
      delete "/api/v4/projects/#{project.id}/labels/#{label.id}", headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect(Label.find_by(id: label.id)).to be_nil
    end

    it 'returns 404 for unknown label' do
      delete "/api/v4/projects/#{project.id}/labels/99999", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
