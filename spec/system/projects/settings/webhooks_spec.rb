require 'rails_helper'

describe 'Webhooks Settings', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'index' do
    it 'shows empty state when no webhooks exist' do
      visit namespace_project_settings_webhooks_path(project.namespace.parent.full_path, project.namespace.path)

      expect(page).to have_content('Webhooks')
      expect(page).to have_content('No webhooks yet')
      expect(page).to have_button('New Webhook')
    end
  end

  describe 'create webhook' do
    it 'creates a new webhook and shows it in the list' do
      visit namespace_project_settings_webhooks_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'New Webhook'
      expect(page).to have_field('project_hook_url')

      fill_in 'project_hook_url', with: 'https://example.com/webhook'
      fill_in 'project_hook_name', with: 'My Webhook'
      fill_in 'project_hook_description', with: 'Test webhook description'
      check 'project_hook_push_events'

      click_button 'Create Project hook'

      expect(page).to have_content('My Webhook')
      expect(page).to have_content('Branch Push events')
    end
  end

  describe 'edit webhook' do
    it 'edits a webhook and shows flash message' do
      visit namespace_project_settings_webhooks_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'New Webhook'
      fill_in 'project_hook_url', with: 'https://example.com/webhook'
      fill_in 'project_hook_name', with: 'Original Name'
      check 'project_hook_push_events'
      click_button 'Create Project hook'

      expect(page).to have_content('Original Name')

      webhook_el = page.first('[id^="webhook-"]')
      webhook_id = webhook_el['id'].match(/\d+/).to_s
      find("#edit-webhook-#{webhook_id}").click

      expect(page).to have_field('project_hook_name', with: 'Original Name')

      fill_in 'project_hook_name', with: 'Updated Name'
      fill_in 'project_hook_description', with: 'Updated description'
      check 'project_hook_tag_push_events'

      click_button 'Update Project hook'

      expect(page).to have_content('Webhook was successfully updated.')
      expect(page).to have_content('Updated Name')
      expect(page).to have_content('Tag push events')
    end
  end

  describe 'delete webhook' do
    it 'creates two webhooks and deletes the correct one' do
      visit namespace_project_settings_webhooks_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'New Webhook'
      fill_in 'project_hook_url', with: 'https://example.com/hook1'
      fill_in 'project_hook_name', with: 'Webhook 1'
      click_button 'Create Project hook'
      expect(page).to have_content('Webhook 1')

      click_button 'New Webhook'
      fill_in 'project_hook_url', with: 'https://example.com/hook2'
      fill_in 'project_hook_name', with: 'Webhook 2'
      click_button 'Create Project hook'
      expect(page).to have_content('Webhook 2')

      webhook_el = page.find('p', text: 'Webhook 1').ancestor('[id^="webhook-"]')
      webhook_id = webhook_el['id'].match(/\d+/).to_s

      page.accept_confirm do
        find("#delete-webhook-#{webhook_id}").click
      end

      expect(page).not_to have_content('Webhook 1')
      expect(page).to have_content('Webhook 2')
    end
  end

  describe 'cancel webhook creation' do
    it 'clicks new webhook then cancel to return to the list' do
      visit namespace_project_settings_webhooks_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'New Webhook'
      expect(page).to have_field('project_hook_url')

      click_link 'Cancel'

      expect(page).to have_button('New Webhook')
      expect(page).to have_content('No webhooks yet')
    end
  end
end
