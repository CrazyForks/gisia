require 'rails_helper'

RSpec.describe 'Admin Users Management', type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:admin) { create(:user, password: password, password_confirmation: password, admin: true) }

  before do
    gisia_sign_in(admin, password: password)
  end

  describe 'index' do
    let_it_be(:user) { create(:user) }

    it 'lists all users' do
      visit admin_users_path

      expect(page).to have_content('Users')
      expect(page).to have_content(admin.username)
      expect(page).to have_content(user.username)
    end

    it 'displays user stats' do
      visit admin_users_path

      expect(page).to have_content('Total Users')
      expect(page).to have_content('Admins')
      expect(page).to have_content('Pending Approval')
      expect(page).to have_content('Active Users')
    end
  end

  describe 'show' do
    let_it_be(:user) { create(:user) }

    it 'displays user details' do
      visit admin_user_path(user)

      expect(page).to have_content(user.username)
      expect(page).to have_content(user.email)
      expect(page).to have_content('Account Details')
    end
  end

  describe 'new' do
    it 'creates a new user' do
      visit new_admin_user_path

      fill_in 'Username', with: 'newuser'
      fill_in 'Email', with: 'newuser@example.com'
      fill_in 'Name', with: 'New User'
      fill_in 'Password', with: 'securepass123', match: :first
      fill_in 'Password confirmation', with: 'securepass123'

      click_button 'Create User'

      expect(page).to have_content('User was successfully created.')
      expect(page).to have_content('newuser')
      expect(page).to have_content('newuser@example.com')
    end
  end

  describe 'edit' do
    let(:user) { create(:user) }

    it 'displays the edit form with disabled username' do
      visit edit_admin_user_path(user)

      expect(page).to have_field('Username', disabled: true)
      expect(page).to have_field('Email', with: user.email)
      expect(page).to have_field('Name', with: user.name)
    end

    it 'updates user details' do
      visit edit_admin_user_path(user)

      fill_in 'Name', with: 'Updated Name'

      click_button 'Update User'

      expect(page).to have_content('User was successfully updated.')
      expect(page).to have_content('Updated Name')
    end

    it 'does not allow username to be changed' do
      original_username = user.username
      visit edit_admin_user_path(user)

      fill_in 'Name', with: 'Updated Name'
      click_button 'Update User'

      user.reload
      expect(user.username).to eq(original_username)
    end
  end

  describe 'delete' do
    let!(:user_to_delete) { create(:user) }

    it 'deletes a user from the show page' do
      visit admin_user_path(user_to_delete)

      click_link 'Delete'

      expect(page).to have_content('User was successfully deleted.')
      expect(page).to have_current_path(admin_users_path)
      expect(page).not_to have_content(user_to_delete.username)
    end
  end
end
