# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V4::Projects::Epics', type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:other_user) { create(:user) }
  let_it_be(:token) { create(:personal_access_token, user: user) }
  let_it_be(:project) { create(:project, creator: user) }

  let(:auth_headers) { { 'PRIVATE-TOKEN' => token.token, 'Accept' => 'application/json' } }

  describe 'Project not found' do
    it 'returns 404 for unknown project id' do
      get '/api/v4/projects/0/epics', headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /api/v4/projects/:id/epics' do
    let_it_be(:epic1) { create(:epic, author: user, namespace: project.namespace, created_at: 2.days.ago) }
    let_it_be(:epic2) { create(:epic, author: user, namespace: project.namespace, created_at: 1.day.ago) }
    let_it_be(:other_project) { create(:project, creator: other_user) }
    let_it_be(:other_epic) { create(:epic, author: other_user, namespace: other_project.namespace) }

    it 'returns only epics belonging to the project namespace' do
      get "/api/v4/projects/#{project.id}/epics", headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to include(epic1.id, epic2.id)
      expect(ids).not_to include(other_epic.id)
    end

    it 'orders epics by created_at desc' do
      get "/api/v4/projects/#{project.id}/epics", headers: auth_headers

      timestamps = json_response.map { |e| Time.parse(e['created_at']) }
      expect(timestamps).to eq(timestamps.sort.reverse)
    end
  end

  describe 'GET /api/v4/projects/:id/epics with filters' do
    let_it_be(:label) { create(:label, namespace: project.namespace, title: 'bug') }
    let_it_be(:author2) { create(:user) }
    let_it_be(:open_epic) { create(:epic, author: user, namespace: project.namespace, title: 'Open Epic Alpha') }
    let_it_be(:closed_epic) do
      e = create(:epic, author: user, namespace: project.namespace, title: 'Closed Epic Beta')
      e.close!(user)
      e
    end
    let_it_be(:labeled_epic) do
      e = create(:epic, author: user, namespace: project.namespace, title: 'Labeled Epic Gamma')
      e.labels << label
      e
    end
    let_it_be(:authored_epic) { create(:epic, author: author2, namespace: project.namespace, title: 'Author Epic Delta') }

    it 'filters by state=opened' do
      get "/api/v4/projects/#{project.id}/epics", params: { state: 'opened' }, headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to include(open_epic.id, labeled_epic.id, authored_epic.id)
      expect(ids).not_to include(closed_epic.id)
    end

    it 'filters by state=closed' do
      get "/api/v4/projects/#{project.id}/epics", params: { state: 'closed' }, headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to include(closed_epic.id)
      expect(ids).not_to include(open_epic.id)
    end

    it 'filters by labels' do
      get "/api/v4/projects/#{project.id}/epics", params: { labels: label.title }, headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to eq([labeled_epic.id])
    end

    it 'filters by author_id' do
      get "/api/v4/projects/#{project.id}/epics", params: { author_id: author2.id }, headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to eq([authored_epic.id])
    end

    it 'filters by iids' do
      get "/api/v4/projects/#{project.id}/epics", params: { iids: [open_epic.iid, closed_epic.iid] }, headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to match_array([open_epic.id, closed_epic.id])
    end

    it 'searches in title' do
      get "/api/v4/projects/#{project.id}/epics", params: { search: 'Alpha', in: 'title' }, headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to eq([open_epic.id])
    end

    it 'searches in title or description by default' do
      get "/api/v4/projects/#{project.id}/epics", params: { search: 'Gamma' }, headers: auth_headers

      ids = json_response.map { |e| e['id'] }
      expect(ids).to eq([labeled_epic.id])
    end
  end

  describe 'GET /api/v4/projects/:id/epics/:epic_iid' do
    let_it_be(:label) { create(:label, namespace: project.namespace) }
    let_it_be(:epic) do
      e = create(:epic, author: user, namespace: project.namespace, due_date: Date.today, confidential: false)
      e.labels << label
      e
    end

    it 'returns the correct epic' do
      get "/api/v4/projects/#{project.id}/epics/#{epic.iid}", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(epic.id)
      expect(json_response['iid']).to eq(epic.iid)
    end

    it 'includes all required fields' do
      get "/api/v4/projects/#{project.id}/epics/#{epic.iid}", headers: auth_headers

      expect(json_response).to include(
        'id' => epic.id,
        'iid' => epic.iid,
        'project_id' => project.id,
        'title' => epic.title,
        'description' => epic.description,
        'state' => 'opened',
        'closed_by' => nil,
        'type' => 'EPIC',
        'confidential' => false
      )
      expect(json_response['labels']).to eq([label.title])
      expect(json_response['author']['id']).to eq(user.id)
      expect(json_response['due_date']).to be_present
      expect(json_response['web_url']).to include('epics')
      expect(json_response['references']['short']).to eq("&#{epic.iid}")
      expect(json_response['references']['full']).to include('&')
      expect(json_response['created_at']).to be_present
      expect(json_response['updated_at']).to be_present
    end

    it 'returns 404 for unknown iid' do
      get "/api/v4/projects/#{project.id}/epics/99999", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v4/projects/:id/epics' do
    it 'creates an epic with title only and returns 201' do
      post "/api/v4/projects/#{project.id}/epics",
        params: { title: 'New Epic' },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['title']).to eq('New Epic')
      expect(json_response['author']['id']).to eq(user.id)
      expect(json_response['type']).to eq('EPIC')
    end

    it 'creates an epic with description, due_date, and confidential' do
      post "/api/v4/projects/#{project.id}/epics",
        params: { title: 'Full Epic', description: 'desc', due_date: '2026-12-31', confidential: true },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['description']).to eq('desc')
      expect(json_response['due_date']).to eq('2026-12-31')
      expect(json_response['confidential']).to be(true)
    end

    it 'returns 422 when title is missing' do
      post "/api/v4/projects/#{project.id}/epics",
        params: { description: 'no title' },
        headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['message']).to be_present
    end
  end

  describe 'PUT /api/v4/projects/:id/epics/:epic_iid' do
    let!(:epic) { create(:epic, author: user, namespace: project.namespace) }

    it 'updates title, description, due_date, and confidential' do
      put "/api/v4/projects/#{project.id}/epics/#{epic.iid}",
        params: { title: 'Updated', description: 'new desc', due_date: '2026-06-30', confidential: true },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['title']).to eq('Updated')
      expect(json_response['description']).to eq('new desc')
      expect(json_response['due_date']).to eq('2026-06-30')
      expect(json_response['confidential']).to be(true)
    end

    it 'closes an epic with state_event=close' do
      put "/api/v4/projects/#{project.id}/epics/#{epic.iid}",
        params: { state_event: 'close' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('closed')
      expect(json_response['closed_at']).not_to be_nil
      expect(json_response['closed_by']['id']).to eq(user.id)
    end

    it 'reopens a closed epic with state_event=reopen' do
      epic.close!(user)

      put "/api/v4/projects/#{project.id}/epics/#{epic.iid}",
        params: { state_event: 'reopen' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('opened')
      expect(json_response['closed_at']).to be_nil
      expect(json_response['closed_by']).to be_nil
    end

    it 'returns 200 when closing an already-closed epic' do
      epic.close!(user)

      put "/api/v4/projects/#{project.id}/epics/#{epic.iid}",
        params: { state_event: 'close' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('closed')
    end

    it 'returns 200 when reopening an already-open epic' do
      put "/api/v4/projects/#{project.id}/epics/#{epic.iid}",
        params: { state_event: 'reopen' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('opened')
    end

    it 'returns 404 for unknown iid' do
      put "/api/v4/projects/#{project.id}/epics/99999",
        params: { title: 'x' },
        headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v4/projects/:id/epics/:epic_iid' do
    let!(:epic) { create(:epic, author: user, namespace: project.namespace) }

    it 'returns 204 and removes the epic from the database' do
      delete "/api/v4/projects/#{project.id}/epics/#{epic.iid}", headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect(Epic.find_by(id: epic.id)).to be_nil
    end

    it 'returns 404 for unknown iid' do
      delete "/api/v4/projects/#{project.id}/epics/99999", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
