require 'rails_helper'

RSpec.describe 'Epic Parent Epic', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'parent epic management on epic show page' do
    let!(:epic) { create(:epic, author: user, namespace: project.namespace, title: 'Child Epic') }
    let!(:parent_epic) { create(:epic, author: user, namespace: project.namespace, title: 'Parent Epic') }

    it 'allows assigning a parent epic' do
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_content('No parent epic')

      within('.epic-sidebar') do
        all_buttons = page.all('button')
        parent_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
        parent_edit_button.click
      end

      fill_in 'Search epics...', with: 'Parent'
      expect(page).to have_css("#epic_card_epic_#{parent_epic.id}")
      page.find("#epic_card_epic_#{parent_epic.id}").click

      expect(page).to have_link('Parent Epic')

      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_link('Parent Epic')
    end

    it 'allows unselecting a parent epic' do
      epic.update!(parent_id: parent_epic.id)
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_link('Parent Epic')

      within('.epic-sidebar') do
        all_buttons = page.all('button')
        parent_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
        parent_edit_button.click
      end

      fill_in 'Search epics...', with: 'Parent'
      expect(page).to have_css("#epic_card_epic_#{parent_epic.id}")
      page.find("#epic_card_epic_#{parent_epic.id}").click

      expect(page).to have_content('No parent epic')

      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_content('No parent epic')
    end

    it 'shows error when assigning epic as its own parent' do
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_content('No parent epic')

      within('.epic-sidebar') do
        all_buttons = page.all('button')
        parent_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
        parent_edit_button.click
      end

      fill_in 'Search epics...', with: 'Child'
      expect(page).to have_css("#epic_card_epic_#{epic.id}")
      page.find("#epic_card_epic_#{epic.id}").click

      expect(page).to have_content('would create a cyclic relationship')
    end
  end
end
