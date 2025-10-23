require 'rails_helper'

RSpec.describe 'Issues', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'creating issues' do
    it 'allows creating a new issue' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path)

      click_link 'New issue'
      expect(page).to have_content('New Issue')

      fill_in 'Title', with: 'Test Issue Title'
      fill_in_lexxy_editor('This is a test issue description', selector: '#issue-description-editor')

      click_button 'Create Issue'

      expect(page).to have_content('Test Issue Title')
      expect(page).to have_content('This is a test issue description')
      expect(page).to have_content('Open')
    end

  end

  describe 'viewing issues' do
    let!(:issue) { create(:issue, author: user, namespace: project.namespace, title: 'Sample Issue') }

    it 'displays issue list' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path)

      expect(page).to have_content('Sample Issue')
      expect(page).to have_content('Open')
    end


    it 'shows status and author in sidebar' do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_content('Status')
      expect(page).to have_content('Author')
      expect(page).to have_content('Assignees')
    end
  end

  describe 'editing issues' do
    let!(:issue) { create(:issue, author: user, namespace: project.namespace, title: 'Original Title') }

    it 'allows editing issue details' do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      click_link 'Edit'
      expect(current_path).to eq(edit_namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue))

      fill_in 'Title', with: 'Updated Issue Title'
      fill_in_lexxy_editor('Updated description', selector: '#issue-description-editor')

      click_button 'Update Issue'

      expect(page).to have_content('Updated Issue Title')
      expect(page).to have_content('Updated description')
    end

  end

  describe 'issue actions' do
    let!(:issue) { create(:issue, author: user, namespace: project.namespace) }

    it 'allows closing an open issue' do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_button('Close')
      click_button 'Close'

      expect(page).to have_content('Closed')
      expect(page).to have_button('Reopen')
    end

    it 'allows reopening a closed issue' do
      issue.update!(state_id: 2) # Closed state
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_button('Reopen')
      click_button 'Reopen'

      expect(page).to have_content('Open')
      expect(page).to have_button('Close')
    end
  end

  describe 'issue filtering and search' do
    let!(:open_issue) { create(:issue, author: user, namespace: project.namespace, title: 'Open Issue') }
    let!(:closed_issue) { create(:issue, author: user, namespace: project.namespace, title: 'Closed Issue', state_id: 2) }

    it 'filters by status' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path)

      expect(page).to have_content('Open Issue')
      expect(page).not_to have_content('Closed Issue')

      click_link 'Closed'
      expect(page).to have_content('Closed Issue')
      expect(page).not_to have_content('Open Issue')
    end

    it 'searches by title' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path)

      fill_in 'Type to search', with: 'Open'
      find('input[name="search"]').send_keys(:enter)

      expect(page).to have_content('Open Issue')
    end
  end

end
