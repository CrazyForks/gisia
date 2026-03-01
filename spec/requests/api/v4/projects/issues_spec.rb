# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V4::Projects::Issues', type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:other_user) { create(:user) }
  let_it_be(:token) { create(:personal_access_token, user: user) }
  let_it_be(:project) { create(:project, creator: user) }

  let(:auth_headers) { { 'PRIVATE-TOKEN' => token.token, 'Accept' => 'application/json' } }
  let(:project_namespace) { project.namespace }

  describe 'Project not found' do
    it 'returns 404 for unknown project id' do
      get '/api/v4/projects/0/issues', headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /api/v4/projects/:id/issues' do
    let_it_be(:issue1) { create(:issue, author: user, namespace: project.namespace, created_at: 2.days.ago) }
    let_it_be(:issue2) { create(:issue, author: user, namespace: project.namespace, created_at: 1.day.ago) }
    let_it_be(:other_project) { create(:project, creator: other_user) }
    let_it_be(:other_issue) { create(:issue, author: other_user, namespace: other_project.namespace) }

    it 'returns only issues belonging to the project' do
      get "/api/v4/projects/#{project.id}/issues", headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(issue1.id, issue2.id)
      expect(ids).not_to include(other_issue.id)
    end

    it 'orders issues by created_at desc' do
      get "/api/v4/projects/#{project.id}/issues", headers: auth_headers

      timestamps = json_response.map { |i| Time.parse(i['created_at']) }
      expect(timestamps).to eq(timestamps.sort.reverse)
    end
  end

  describe 'GET /api/v4/projects/:id/issues/:issue_iid' do
    let_it_be(:label) { create(:label, namespace: project.namespace) }
    let_it_be(:assignee) { create(:user) }
    let_it_be(:issue) do
      i = create(:issue, author: user, namespace: project.namespace, due_date: Date.today, confidential: false)
      i.assignees << assignee
      i.labels << label
      i
    end

    it 'returns the correct issue' do
      get "/api/v4/projects/#{project.id}/issues/#{issue.iid}", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(issue.id)
      expect(json_response['iid']).to eq(issue.iid)
    end

    it 'includes all required fields' do
      get "/api/v4/projects/#{project.id}/issues/#{issue.iid}", headers: auth_headers

      expect(json_response).to include(
        'id' => issue.id,
        'iid' => issue.iid,
        'project_id' => project.id,
        'title' => issue.title,
        'description' => issue.description,
        'state' => 'opened',
        'closed_by' => nil,
        'type' => 'ISSUE',
        'confidential' => false
      )
      expect(json_response['labels']).to eq([label.title])
      expect(json_response['assignees'].map { |a| a['id'] }).to eq([assignee.id])
      expect(json_response['assignee']['id']).to eq(assignee.id)
      expect(json_response['author']['id']).to eq(user.id)
      expect(json_response['due_date']).to be_present
      expect(json_response['web_url']).to include(issue.iid.to_s)
      expect(json_response['references']).to include('short', 'relative', 'full')
      expect(json_response['created_at']).to be_present
      expect(json_response['updated_at']).to be_present
    end

    it 'returns 404 for unknown iid' do
      get "/api/v4/projects/#{project.id}/issues/99999", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v4/projects/:id/issues' do
    it 'creates an issue with title only and returns 201' do
      post "/api/v4/projects/#{project.id}/issues",
        params: { title: 'New Issue' },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['title']).to eq('New Issue')
      expect(json_response['author']['id']).to eq(user.id)
    end

    it 'creates an issue with description, due_date, and confidential' do
      post "/api/v4/projects/#{project.id}/issues",
        params: { title: 'Full Issue', description: 'desc', due_date: '2026-12-31', confidential: true },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['description']).to eq('desc')
      expect(json_response['due_date']).to eq('2026-12-31')
      expect(json_response['confidential']).to be(true)
    end

    it 'creates an issue with assignees' do
      assignee = create(:user)

      post "/api/v4/projects/#{project.id}/issues",
        params: { title: 'Assigned Issue', assignee_ids: [assignee.id] },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['assignees'].map { |a| a['id'] }).to include(assignee.id)
    end

    it 'creates an issue with labels scoped to project namespace' do
      label = create(:label, namespace: project.namespace)

      post "/api/v4/projects/#{project.id}/issues",
        params: { title: 'Labeled Issue', label_ids: [label.id] },
        headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(json_response['labels']).to include(label.title)
    end

    it 'returns 422 when title is missing' do
      post "/api/v4/projects/#{project.id}/issues",
        params: { description: 'no title' },
        headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['message']).to be_present
    end
  end

  describe 'PUT /api/v4/projects/:id/issues/:issue_iid' do
    let!(:issue) { create(:issue, author: user, namespace: project.namespace) }

    it 'updates title, description, due_date, and confidential' do
      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { title: 'Updated', description: 'new desc', due_date: '2026-06-30', confidential: true },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['title']).to eq('Updated')
      expect(json_response['description']).to eq('new desc')
      expect(json_response['due_date']).to eq('2026-06-30')
      expect(json_response['confidential']).to be(true)
    end

    it 'closes an issue with state_event=close' do
      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { state_event: 'close' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('closed')
      expect(json_response['closed_at']).not_to be_nil
      expect(json_response['closed_by']['id']).to eq(user.id)
      expect(json_response['closed_by']['username']).to eq(user.username)
    end

    it 'reopens a closed issue with state_event=reopen' do
      issue.close(user)

      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { state_event: 'reopen' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('opened')
      expect(json_response['closed_at']).to be_nil
      expect(json_response['closed_by']).to be_nil
    end

    it 'returns 200 when closing an already-closed issue' do
      issue.close(user)

      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { state_event: 'close' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('closed')
    end

    it 'returns 200 when reopening an already-open issue' do
      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { state_event: 'reopen' },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['state']).to eq('opened')
    end

    it 'adds labels without removing existing ones with add_label_ids' do
      existing_label = create(:label, namespace: project.namespace)
      new_label = create(:label, namespace: project.namespace)
      issue.labels << existing_label

      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { add_label_ids: [new_label.id] },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['labels']).to include(existing_label.title, new_label.title)
    end

    it 'removes specified labels and keeps others with remove_label_ids' do
      keep_label = create(:label, namespace: project.namespace)
      remove_label = create(:label, namespace: project.namespace)
      issue.labels << [keep_label, remove_label]

      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { remove_label_ids: [remove_label.id] },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['labels']).to include(keep_label.title)
      expect(json_response['labels']).not_to include(remove_label.title)
    end

    it 'replaces all assignees with assignee_ids' do
      old_assignee = create(:user)
      new_assignee = create(:user)
      issue.assignees << old_assignee

      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { assignee_ids: [new_assignee.id] },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['assignees'].map { |a| a['id'] }).to eq([new_assignee.id])
    end

    it 'links the issue to an epic with epic_id' do
      epic = create(:epic, namespace: project.namespace)

      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { epic_id: epic.id },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['epic_id']).to eq(epic.id)
      expect(issue.reload.parent_id).to eq(epic.id)
    end

    it 'unlinks the issue from an epic with epic_id null' do
      epic = create(:epic, namespace: project.namespace)
      issue.update_column(:parent_id, epic.id)

      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { epic_id: nil },
        headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json_response['epic_id']).to be_nil
      expect(issue.reload.parent_id).to be_nil
    end

    it 'returns 404 when epic_id does not exist' do
      put "/api/v4/projects/#{project.id}/issues/#{issue.iid}",
        params: { epic_id: 0 },
        headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 for unknown iid' do
      put "/api/v4/projects/#{project.id}/issues/99999",
        params: { title: 'x' },
        headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v4/projects/:id/issues/:issue_iid' do
    let!(:issue) { create(:issue, author: user, namespace: project.namespace) }

    it 'returns 204 and removes the issue from the database' do
      delete "/api/v4/projects/#{project.id}/issues/#{issue.iid}", headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect(Issue.find_by(id: issue.id)).to be_nil
    end

    it 'returns 404 for unknown iid' do
      delete "/api/v4/projects/#{project.id}/issues/99999", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
