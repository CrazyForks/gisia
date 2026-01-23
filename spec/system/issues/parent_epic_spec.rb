require 'rails_helper'

RSpec.describe 'Issue Parent Epic', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'parent epic management on issue show page' do
    let!(:issue) { create(:issue, author: user, namespace: project.namespace, title: 'Test Issue') }
    let!(:epic) { create(:epic, author: user, namespace: project.namespace, title: 'Test Epic') }

    it 'allows assigning a parent epic' do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_content('No parent epic')

      within('.issue-sidebar') do
        all_buttons = page.all('button')
        parent_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
        parent_edit_button.click
      end

      fill_in 'Search epics...', with: 'Test Epic'
      expect(page).to have_css("#epic_card_epic_#{epic.id}")
      page.find("#epic_card_epic_#{epic.id}").click

      expect(page).to have_link('Test Epic')

      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_link('Test Epic')
    end

    it 'allows unselecting a parent epic' do
      issue.update!(parent_id: epic.id)
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_link('Test Epic')

      within('.issue-sidebar') do
        all_buttons = page.all('button')
        parent_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
        parent_edit_button.click
      end

      fill_in 'Search epics...', with: 'Test Epic'
      expect(page).to have_css("#epic_card_epic_#{epic.id}")
      page.find("#epic_card_epic_#{epic.id}").click

      expect(page).to have_content('No parent epic')

      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_content('No parent epic')
    end
  end
end
