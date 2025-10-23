require 'rails_helper'

RSpec.describe 'User Login', type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:password_confirmation) { password }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password_confirmation) }

  it 'allows user to login with username and password' do
    login_as(user)

    expect(page).to have_current_path(root_path)
  end

  it 'shows error message for invalid credentials' do
    visit new_user_session_path

    fill_in 'user[username]', with: user.username
    fill_in 'user[password]', with: 'wrongpassword'
    click_button 'Log in'

    expect(page).to have_content('Invalid Username or password')
    expect(page).to have_current_path(new_user_session_path)
  end
end
