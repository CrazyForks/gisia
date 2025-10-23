require 'rails_helper'

RSpec.describe 'Group Management', type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'creating a group' do
    it 'allows user to create a new group' do
      visit new_dashboard_group_path

      fill_in 'Group Name', with: 'Test Group'
      fill_in 'Group Path', with: 'test-group'
      fill_in 'Description', with: 'This is a test group'

      click_button 'Create Group'

      expect(page).to have_content('Test Group')
    end

  end

  describe 'updating a group' do
    let_it_be(:group) { create(:group, creator: user) }

    it 'allows user to update group details' do
      visit edit_dashboard_group_path(group)

      fill_in 'Group Name', with: 'Updated Group Name'
      fill_in 'Description', with: 'Updated description'

      click_button 'Update Group'

      expect(page).to have_content('Updated Group Name')
    end
  end

  describe 'deleting a group' do
    let_it_be(:group) { create(:group, creator: user) }

    it 'allows user to delete a group' do
      visit dashboard_group_path(group)

      # Click the menu dropdown (dots icon)
      find('[data-action="click->dashboard#toggleMenu"]').click
      
      # Click delete and confirm
      click_button 'Delete'

      expect(current_path).to eq(dashboard_groups_path)
    end
  end
end
