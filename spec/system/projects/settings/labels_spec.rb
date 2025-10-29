require 'rails_helper'

describe 'Labels Settings', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'create and edit labels' do
    it 'creates a new label and shows it in the list, then edits it twice' do
      visit namespace_project_settings_labels_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'New Label'
      expect(page).to have_field('label_title')

      fill_in 'label_title', with: 'Bug'
      fill_in 'label_description', with: 'Bug reports'

      click_button 'Create Label'

      expect(page).to have_content('Bug')
      expect(page).to have_content('Bug reports')

      bug_label = page.first('[id^="label-"]')
      bug_id = bug_label['id'].match(/\d+/).to_s
      find("#edit-label-#{bug_id}").click
      expect(page).to have_field('label_title', with: 'Bug')

      fill_in 'label_title', with: 'Feature'
      fill_in 'label_description', with: 'Feature requests'

      click_button 'Update Label'

      expect(page).to have_content('Feature')
      expect(page).to have_content('Feature requests')

      feature_label = page.first('[id^="label-"]')
      feature_id = feature_label['id'].match(/\d+/).to_s
      find("#edit-label-#{feature_id}").click
      expect(page).to have_field('label_title', with: 'Feature')

      fill_in 'label_title', with: 'Enhancement'
      fill_in 'label_description', with: 'Enhancement tasks'

      click_button 'Update Label'

      expect(page).to have_content('Enhancement')
      expect(page).to have_content('Enhancement tasks')
    end
  end

  describe 'delete labels' do
    it 'creates three labels and deletes the correct one' do
      visit namespace_project_settings_labels_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'New Label'
      fill_in 'label_title', with: 'Label 1'
      click_button 'Create Label'

      expect(page).to have_content('Label 1')

      click_button 'New Label'
      fill_in 'label_title', with: 'Label 2'
      click_button 'Create Label'

      expect(page).to have_content('Label 2')

      click_button 'New Label'
      fill_in 'label_title', with: 'Label 3'
      click_button 'Create Label'

      expect(page).to have_content('Label 3')

      label_2 = page.find('p', text: 'Label 2').ancestor('[id^="label-"]')
      label_2_id = label_2['id'].match(/\d+/).to_s

      page.accept_confirm do
        find("#delete-label-#{label_2_id}").click
      end

      expect(page).to have_content('Label 1')
      expect(page).not_to have_content('Label 2')
      expect(page).to have_content('Label 3')
    end
  end

  describe 'cancel label creation' do
    it 'clicks create label button then cancel to show the list' do
      visit namespace_project_settings_labels_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'New Label'
      expect(page).to have_field('label_title')

      click_link 'Cancel'

      expect(page).to have_button('New Label')
      expect(page).to have_text('Create and manage project labels')
    end
  end
end
