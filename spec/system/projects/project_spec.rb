require 'rails_helper'

RSpec.describe 'Project Management', type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'creating a project under user namespace' do
    it 'allows user to create a project under their user namespace' do
      visit new_dashboard_project_path

      fill_in 'Project Name', with: 'My Test Project'
      fill_in 'Project Path', with: 'my-test-project'
      fill_in 'Description', with: 'This is a test project'
      select user.namespace.name_with_type, from: 'Namespace'

      click_button 'Create Project'

      expect(page).to have_content('Project was successfully created')
      expect(page).to have_content('My Test Project')
    end
  end

  describe 'creating a project under a new namespace' do
    let_it_be(:group) { create(:group, creator: user) }

    it 'allows user to create a project under a group namespace' do
      visit new_dashboard_project_path

      fill_in 'Project Name', with: 'Group Project'
      fill_in 'Project Path', with: 'group-project'
      fill_in 'Description', with: 'This is a group project'
      select group.namespace.name_with_type, from: 'Namespace'

      click_button 'Create Project'

      expect(page).to have_content('Project was successfully created')
      expect(page).to have_content('Group Project')
    end
  end

  describe 'viewing project details' do
    let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

    it 'displays project information correctly' do
      visit dashboard_project_path(project)

      expect(page).to have_content(project.name)
      expect(page).to have_content("Path: #{project.path}")
      expect(page).to have_content('SSH URL:')
    end
  end

  describe 'deleting a project' do
    let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

    it 'allows user to delete a project' do
      visit dashboard_project_path(project)

      # Click the menu dropdown (dots icon)
      find('[data-action="click->dashboard#toggleMenu"]').click
      
      # Click delete and confirm
      click_button 'Delete'

      expect(page).to have_content('Project was successfully destroyed')
      expect(current_path).to eq(dashboard_projects_path)
    end
  end
end