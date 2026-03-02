require 'rails_helper'

RSpec.describe 'Projects::AccessControl', type: :request do
  include Devise::Test::IntegrationHelpers

  let_it_be(:admin) { create(:user, admin: true) }
  let_it_be(:owner) { create(:user) }
  let_it_be(:project) { create(:project, creator: owner, parent_namespace: owner.namespace) }
  let_it_be(:maintainer_user) { create(:user) }
  let_it_be(:developer_user) { create(:user) }
  let_it_be(:non_member) { create(:user) }
  let_it_be(:expired_user) { create(:user) }

  let_it_be(:maintainer_member) do
    create(:project_member, user: maintainer_user, project: project, access_level: :maintainer)
  end

  let_it_be(:developer_member) do
    create(:project_member, user: developer_user, project: project, access_level: :developer)
  end

  let_it_be(:expired_member) do
    create(:project_member, user: expired_user, project: project, access_level: :maintainer, expires_at: 1.day.ago)
  end

  let(:project_path) do
    namespace_project_path(project.namespace.parent.full_path, project.path)
  end

  let(:settings_path) do
    namespace_project_settings_members_path(project.namespace.parent.full_path, project.namespace.path)
  end

  describe 'visibility: private project' do
    context 'when unauthenticated' do
      it 'redirects to login' do
        get project_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'when logged in as a non-member' do
      before { sign_in non_member }

      it 'returns 404' do
        get project_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when logged in as a member' do
      before { sign_in developer_user }

      it 'returns 200' do
        get project_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'visibility: internal project' do
    let_it_be(:internal_project) do
      create(:project, creator: owner, parent_namespace: owner.namespace).tap do |p|
        p.namespace.update!(visibility_level: Gitlab::VisibilityLevel::INTERNAL)
      end
    end

    let(:internal_project_path) do
      namespace_project_path(internal_project.namespace.parent.full_path, internal_project.path)
    end

    context 'when unauthenticated' do
      it 'redirects to login' do
        get internal_project_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'when logged in as any user (non-member)' do
      before { sign_in non_member }

      it 'returns 200' do
        get internal_project_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'visibility: public project' do
    let_it_be(:public_project) do
      create(:project, creator: owner, parent_namespace: owner.namespace).tap do |p|
        p.namespace.update!(visibility_level: Gitlab::VisibilityLevel::PUBLIC)
      end
    end

    let(:public_project_path) do
      namespace_project_path(public_project.namespace.parent.full_path, public_project.path)
    end

    context 'when unauthenticated' do
      it 'returns 200' do
        get public_project_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'project access (authorize_project_access!)' do
    context 'when user is a non-member' do
      before { sign_in non_member }

      it 'returns 404' do
        get project_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user has expired membership' do
      before do
        RemoveExpiredMembersJob.new.perform
        sign_in expired_user
      end

      it 'returns 404' do
        get project_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is a developer member' do
      before { sign_in developer_user }

      it 'returns 200' do
        get project_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is a maintainer member' do
      before { sign_in maintainer_user }

      it 'returns 200' do
        get project_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is an admin' do
      before { sign_in admin }

      it 'returns 200' do
        get project_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'settings access (authorize_settings_access!)' do
    context 'when user is a developer member' do
      before { sign_in developer_user }

      it 'returns 403' do
        get settings_path
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is a maintainer member' do
      before { sign_in maintainer_user }

      it 'returns 200' do
        get settings_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is the owner' do
      before { sign_in owner }

      it 'returns 200' do
        get settings_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is an admin' do
      before { sign_in admin }

      it 'returns 200' do
        get settings_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user has expired maintainer membership' do
      before do
        RemoveExpiredMembersJob.new.perform
        sign_in expired_user
      end

      it 'returns 404 from project access check' do
        get settings_path
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
