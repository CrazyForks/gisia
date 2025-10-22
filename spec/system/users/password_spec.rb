require 'rails_helper'

RSpec.describe 'User Password Change',type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:password_confirmation) { password }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password_confirmation) }

  before do
    login_as(user)
  end

  describe 'password change page' do
    it 'displays the password change form' do
      visit edit_users_settings_password_path

      expect(page).to have_current_path(edit_users_settings_password_path)
      expect(page).to have_content('Change Password')
      expect(page).to have_content('Update your account password')
      expect(page).to have_field('Current Password')
      expect(page).to have_field('New Password')
      expect(page).to have_field('Confirm Password')
      expect(page).to have_button('Change Password')
    end

    it 'shows password menu in sidebar' do
      visit users_settings_profile_path

      expect(page).to have_link('Password', href: edit_users_settings_password_path)
    end
  end

  describe 'password change' do
    it 'shows error when current password is blank' do
      visit edit_users_settings_password_path

      fill_in 'Current Password', with: ''
      fill_in 'New Password', with: 'newpassword123'
      fill_in 'Confirm Password', with: 'newpassword123'
      click_button 'Change Password'

      expect(page).to have_content("Current password can't be blank")
    end

    it 'shows error when current password is incorrect' do
      visit edit_users_settings_password_path

      fill_in 'Current Password', with: 'wrongpassword'
      fill_in 'New Password', with: 'newpassword123'
      fill_in 'Confirm Password', with: 'newpassword123'
      click_button 'Change Password'

      expect(page).to have_content('Current password is invalid')
    end
  end
end
