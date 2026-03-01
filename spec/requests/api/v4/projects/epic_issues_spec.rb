# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V4::Projects::EpicIssues', type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:token) { create(:personal_access_token, user: user) }
  let_it_be(:project) { create(:project, creator: user) }
  let_it_be(:epic) { create(:epic, author: user, namespace: project.namespace) }

  let(:auth_headers) { { 'PRIVATE-TOKEN' => token.token, 'Accept' => 'application/json' } }

  describe 'Epic not found' do
    it 'returns 404 for unknown epic iid' do
      get "/api/v4/projects/#{project.id}/epics/99999/issues", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /api/v4/projects/:id/epics/:epic_iid/issues' do
    let_it_be(:issue1) { create(:issue, author: user, namespace: project.namespace, created_at: 2.days.ago) }
    let_it_be(:issue2) { create(:issue, author: user, namespace: project.namespace, created_at: 1.day.ago) }
    let_it_be(:unlinked_issue) { create(:issue, author: user, namespace: project.namespace) }

    before do
      issue1.update_column(:parent_id, epic.id)
      issue2.update_column(:parent_id, epic.id)
    end

    it 'returns only issues linked to the epic' do
      get "/api/v4/projects/#{project.id}/epics/#{epic.iid}/issues", headers: auth_headers

      expect(response).to have_http_status(:ok)
      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(issue1.id, issue2.id)
      expect(ids).not_to include(unlinked_issue.id)
    end

    it 'orders issues by created_at desc' do
      get "/api/v4/projects/#{project.id}/epics/#{epic.iid}/issues", headers: auth_headers

      timestamps = json_response.map { |i| Time.parse(i['created_at']) }
      expect(timestamps).to eq(timestamps.sort.reverse)
    end

    it 'returns issues with type ISSUE' do
      get "/api/v4/projects/#{project.id}/epics/#{epic.iid}/issues", headers: auth_headers

      expect(json_response.first['type']).to eq('ISSUE')
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
