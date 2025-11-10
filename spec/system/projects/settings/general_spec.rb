require 'rails_helper'

describe 'Project General Settings', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'update project settings' do
    it 'opens the edit form and updates successfully' do
      visit edit_namespace_project_path(project.namespace.parent.full_path, project.path)

      expect(page).to have_field('project_name', with: project.name)
      expect(page).to have_field('project_path', with: project.path)
      expect(page).to have_field('project_workflows')

      click_button 'Update Project'

      expect(page).to have_field('project_name', with: project.name)
    end
  end
end
