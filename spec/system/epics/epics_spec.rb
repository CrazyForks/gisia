require 'rails_helper'

RSpec.describe 'Epics', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'creating epics' do
    it 'allows creating a new epic' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path)

      click_link 'New epic'
      expect(page).to have_content('New Epic')

      fill_in 'Title', with: 'Test Epic Title'
      fill_in_lexxy_editor('This is a test epic description', selector: '#epic-description-editor')

      click_button 'Create Epic'

      expect(page).to have_content('Test Epic Title')
      expect(page).to have_content('This is a test epic description')
      expect(page).to have_content('Open')
    end
  end

  describe 'viewing epics' do
    let!(:epic) { create(:epic, author: user, namespace: project.namespace, title: 'Sample Epic') }

    it 'displays epic list' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path)

      expect(page).to have_content('Sample Epic')
      expect(page).to have_content('Open')
    end

    it 'shows status and author in sidebar' do
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_content('Status')
      expect(page).to have_content('Author')
      expect(page).to have_content('Assignees')
    end
  end

  describe 'editing epics' do
    let!(:epic) { create(:epic, author: user, namespace: project.namespace, title: 'Original Epic Title') }

    it 'allows editing epic details' do
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      click_link 'Edit'
      expect(current_path).to eq(edit_namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic))

      fill_in 'Title', with: 'Updated Epic Title'
      fill_in_lexxy_editor('Updated epic description', selector: '#epic-description-editor')

      # Check if form shows any validation errors before submitting
      click_button 'Update Epic'

      # If there are validation errors, they should show on the edit page
      if page.has_content?('prohibited this epic from being saved')
        fail "Epic update failed with validation errors: #{page.text}"
      end

      # Wait for redirect and page update
      expect(page).to have_content('Updated Epic Title', wait: 5)
      expect(page).to have_content('Updated epic description', wait: 5)
    end
  end

  describe 'epic actions' do
    let!(:epic) { create(:epic, author: user, namespace: project.namespace) }

    it 'allows closing an open epic' do
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_button('Close')
      click_button 'Close'

      expect(page).to have_content('Closed')
      expect(page).to have_button('Reopen')
    end

    it 'allows reopening a closed epic' do
      epic.update!(state_id: 2) # Closed state
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_button('Reopen')
      click_button 'Reopen'

      expect(page).to have_content('Open')
      expect(page).to have_button('Close')
    end
  end

  describe 'epic filtering and search' do
    let!(:open_epic) { create(:epic, author: user, namespace: project.namespace, title: 'Open Epic') }
    let!(:closed_epic) { create(:epic, author: user, namespace: project.namespace, title: 'Closed Epic', state_id: 2) }

    it 'filters by status' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path)

      expect(page).to have_content('Open Epic')
      expect(page).not_to have_content('Closed Epic')

      click_link 'Closed'
      expect(page).to have_content('Closed Epic')
      expect(page).not_to have_content('Open Epic')
    end

    it 'searches by title' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path)

      fill_in 'Search by title', with: 'Open'
      find('input[name="search"]').send_keys(:enter)

      expect(page).to have_content('Open Epic')
    end
  end
end
