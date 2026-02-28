# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V4::Issues', type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:other_user) { create(:user) }
  let_it_be(:token) { create(:personal_access_token, user: user) }

  let(:auth_headers) { { 'PRIVATE-TOKEN' => token.token, 'Accept' => 'application/json' } }

  describe 'Authentication' do
    it 'returns 401 when token is missing' do
      get '/api/v4/issues'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 when token is invalid' do
      get '/api/v4/issues', headers: { 'PRIVATE-TOKEN' => 'invalid-token' }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/v4/issues' do
    let_it_be(:namespace) { create(:namespace) }
    let_it_be(:authored_issue) { create(:issue, author: user, namespace: namespace) }
    let_it_be(:assigned_issue) do
      issue = create(:issue, author: other_user, namespace: namespace)
      issue.assignees << user
      issue
    end
    let_it_be(:unrelated_issue) { create(:issue, author: other_user, namespace: namespace) }

    it 'returns issues where current user is the author' do
      get '/api/v4/issues', headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(authored_issue.id)
    end

    it 'returns issues where current user is an assignee' do
      get '/api/v4/issues', headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(assigned_issue.id)
    end

    it 'excludes issues where user has no relationship' do
      get '/api/v4/issues', headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).not_to include(unrelated_issue.id)
    end

    it 'filters by state=opened' do
      closed_issue = create(:issue, author: user, namespace: namespace)
      closed_issue.close(user)

      get '/api/v4/issues', params: { state: 'opened' }, headers: auth_headers

      states = json_response.map { |i| i['state'] }
      expect(states).to all(eq('opened'))
    end

    it 'filters by state=closed' do
      closed_issue = create(:issue, author: user, namespace: namespace)
      closed_issue.close(user)

      get '/api/v4/issues', params: { state: 'closed' }, headers: auth_headers

      states = json_response.map { |i| i['state'] }
      expect(states).to all(eq('closed'))
    end

    it 'filters by labels with AND logic' do
      label1 = create(:label, namespace: namespace, title: 'bug')
      label2 = create(:label, namespace: namespace, title: 'urgent')
      issue_both = create(:issue, author: user, namespace: namespace)
      issue_one = create(:issue, author: user, namespace: namespace)
      issue_both.labels << [label1, label2]
      issue_one.labels << label1

      get '/api/v4/issues', params: { labels: 'bug,urgent' }, headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(issue_both.id)
      expect(ids).not_to include(issue_one.id)
    end

    it 'filters by author_id' do
      get '/api/v4/issues', params: { author_id: user.id }, headers: auth_headers

      author_ids = json_response.map { |i| i['author']['id'] }
      expect(author_ids).to all(eq(user.id))
    end

    it 'filters by assignee_id' do
      get '/api/v4/issues', params: { assignee_id: user.id }, headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(assigned_issue.id)
      expect(ids).not_to include(authored_issue.id)
    end

    it 'filters by iids array' do
      get '/api/v4/issues', params: { iids: [authored_issue.iid] }, headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to eq([authored_issue.id])
    end

    it 'searches title and description by default' do
      searchable = create(:issue, author: user, namespace: namespace, title: 'unique-xyz-title')

      get '/api/v4/issues', params: { search: 'unique-xyz-title' }, headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(searchable.id)
    end

    it 'searches title only when in=title' do
      title_match = create(:issue, author: user, namespace: namespace, title: 'findme-title-only')
      desc_match = create(:issue, author: user, namespace: namespace, title: 'other', description: 'findme-title-only')

      get '/api/v4/issues', params: { search: 'findme-title-only', in: 'title' }, headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(title_match.id)
      expect(ids).not_to include(desc_match.id)
    end

    it 'searches description only when in=description' do
      desc_match = create(:issue, author: user, namespace: namespace, description: 'findme-desc-only')
      title_match = create(:issue, author: user, namespace: namespace, title: 'findme-desc-only')

      get '/api/v4/issues', params: { search: 'findme-desc-only', in: 'description' }, headers: auth_headers

      ids = json_response.map { |i| i['id'] }
      expect(ids).to include(desc_match.id)
      expect(ids).not_to include(title_match.id)
    end

    it 'orders results by created_at desc' do
      get '/api/v4/issues', headers: auth_headers

      timestamps = json_response.map { |i| Time.parse(i['created_at']) }
      expect(timestamps).to eq(timestamps.sort.reverse)
    end

    context 'with pagination' do
      let_it_be(:ns) { create(:namespace) }
      let_it_be(:issue1) { create(:issue, author: user, namespace: ns, created_at: 3.days.ago) }
      let_it_be(:issue2) { create(:issue, author: user, namespace: ns, created_at: 2.days.ago) }
      let_it_be(:issue3) { create(:issue, author: user, namespace: ns, created_at: 1.day.ago) }

      it 'returns 2 items with per_page=2 on page 1 and sets headers' do
        get '/api/v4/issues', params: { per_page: 2, page: 1 }, headers: auth_headers

        expect(json_response.length).to be >= 2
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('2')
        expect(response.headers['X-Next-Page']).to be_present
      end

      it 'sets correct pagination headers for total counts' do
        get '/api/v4/issues', params: { per_page: 2, page: 1, author_id: user.id, iids: [issue1.iid, issue2.iid, issue3.iid] }, headers: auth_headers

        expect(response.headers['X-Total'].to_i).to eq(3)
        expect(response.headers['X-Total-Pages'].to_i).to eq(2)
        expect(response.headers['X-Page']).to eq('1')
        expect(response.headers['X-Per-Page']).to eq('2')
        expect(response.headers['X-Next-Page']).to eq('2')
        expect(json_response.length).to eq(2)
      end

      it 'sets X-Prev-Page on page 2 and empty X-Next-Page when last page' do
        get '/api/v4/issues', params: { per_page: 2, page: 2, author_id: user.id, iids: [issue1.iid, issue2.iid, issue3.iid] }, headers: auth_headers

        expect(response.headers['X-Prev-Page']).to eq('1')
        expect(response.headers['X-Next-Page']).to eq('')
        expect(json_response.length).to eq(1)
      end

    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
