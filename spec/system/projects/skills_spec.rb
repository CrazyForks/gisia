# frozen_string_literal: true

require 'rails_helper'

describe 'Project Skill MD', type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }

  def skill_md_path(project)
    namespace_project_project_skill_md_path(project.namespace.parent.full_path, project.namespace.path)
  end

  def issues_skill_md_path(project)
    namespace_project_issues_skill_md_path(project.namespace.parent.full_path, project.namespace.path)
  end

  def epics_skill_md_path(project)
    namespace_project_epics_skill_md_path(project.namespace.parent.full_path, project.namespace.path)
  end

  def labels_skill_md_path(project)
    namespace_project_labels_skill_md_path(project.namespace.parent.full_path, project.namespace.path)
  end

  describe '/-/users/skill.md' do
    it 'cannot be accessed without login' do
      visit users_skill_md_path

      expect(page.status_code).to eq(401)
    end

    it 'can be accessed with a personal access token', :js do
      token = create(:personal_access_token, user: user)
      page.driver.headers = { 'PRIVATE-TOKEN' => token.token }
      visit users_skill_md_path

      expect(page.status_code).to eq(200)
    end
  end

  context 'public project' do
    let_it_be(:project) do
      p = create(:project, creator: user, parent_namespace: user.namespace)
      p.namespace.update!(visibility_level: Gitlab::VisibilityLevel::PUBLIC)
      p
    end

    it 'can be accessed without login' do
      visit skill_md_path(project)

      expect(page.status_code).to eq(200)
    end

    it 'issues skill can be accessed without login' do
      visit issues_skill_md_path(project)

      expect(page.status_code).to eq(200)
    end

    it 'epics skill can be accessed without login' do
      visit epics_skill_md_path(project)

      expect(page.status_code).to eq(200)
    end

    it 'labels skill can be accessed without login' do
      visit labels_skill_md_path(project)

      expect(page.status_code).to eq(200)
    end
  end

  context 'private project' do
    let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

    it 'cannot be accessed without login' do
      visit skill_md_path(project)

      expect(page.status_code).to eq(401)
    end

    it 'can be accessed with login' do
      gisia_sign_in(user, password: password)
      visit skill_md_path(project)

      expect(page.status_code).to eq(200)
    end

    it 'can be accessed with a personal access token', :js do
      token = create(:personal_access_token, user: user)
      page.driver.headers = { 'PRIVATE-TOKEN' => token.token }
      visit skill_md_path(project)

      expect(page.status_code).to eq(200)
    end
  end
end
