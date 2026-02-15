require 'rails_helper'

RSpec.describe 'Admin Projects Management', type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:admin) { create(:user, password: password, password_confirmation: password, admin: true) }

  before do
    gisia_sign_in(admin, password: password)
  end

  describe 'edit' do
    let(:project) { create(:project, name: 'My Project', path: 'my-project', creator: admin) }

    it 'displays the edit form with editable path field' do
      visit edit_admin_project_path(project)

      expect(page).to have_field('Project name', with: 'My Project')
      expect(page).to have_field('Project path', with: 'my-project')
      expect(page).not_to have_field('Project path', disabled: true)
      expect(page).not_to have_field('Project path', readonly: true)
    end

    it 'updates the project path' do
      visit edit_admin_project_path(project)

      fill_in 'Project path', with: 'updated-path'
      click_button 'Update Project'

      expect(page).to have_content('Project was successfully updated.')
      project.reload
      expect(project.path).to eq('updated-path')
    end
  end
end
