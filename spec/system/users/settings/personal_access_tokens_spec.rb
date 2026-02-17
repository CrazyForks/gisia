require 'rails_helper'

RSpec.describe 'Personal Access Tokens', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }

  before do
    login_as(user)
  end

  describe 'index page' do
    it 'displays page heading and Add Token button' do
      visit users_settings_personal_access_tokens_path

      expect(page).to have_content('Personal Access Tokens')
      expect(page).to have_link('Add Token')
    end

    it 'lists existing tokens with name, scopes, created date, and expiration' do
      token = create(:personal_access_token, user: user, name: 'my-test-token', scopes: [:api], expires_at: 30.days.from_now)

      visit users_settings_personal_access_tokens_path

      expect(page).to have_content('my-test-token')
      expect(page).to have_content('api')
      expect(page).to have_content("Created #{token.created_at.strftime('%b %d, %Y')}")
      expect(page).to have_content("Expires #{token.expires_at.strftime('%b %d, %Y')}")
    end

    it 'shows Revoked badge for revoked tokens' do
      create(:personal_access_token, :revoked, user: user, name: 'revoked-token')

      visit users_settings_personal_access_tokens_path

      expect(page).to have_content('revoked-token')
      expect(page).to have_content('Revoked')
    end

    it 'shows empty state when no tokens exist' do
      visit users_settings_personal_access_tokens_path

      expect(page).to have_content('No tokens found')
      expect(page).to have_link('Add Your First Token')
    end
  end

  describe 'add token' do
    it 'navigates to new page when clicking Add Token' do
      visit users_settings_personal_access_tokens_path

      click_link 'Add Token'

      expect(page).to have_current_path(new_users_settings_personal_access_token_path)
      expect(page).to have_content('Add Access Token')
    end

    it 'creates a token with valid data and shows the token value' do
      visit new_users_settings_personal_access_token_path

      fill_in 'Token name', with: 'deploy-token'
      fill_in 'Expiration date', with: 30.days.from_now.to_date.to_s
      check 'api'
      click_button 'Create personal access token'

      expect(page).to have_current_path(users_settings_personal_access_tokens_path)
      expect(page).to have_content('Your new personal access token has been created')
      expect(page).to have_content('deploy-token')
    end
  end

  describe 'revoke token' do
    it 'revokes the token and shows Revoked badge' do
      create(:personal_access_token, user: user, name: 'token-to-revoke')

      visit users_settings_personal_access_tokens_path

      expect(page).to have_content('token-to-revoke')

      accept_confirm do
        click_button 'Revoke'
      end

      expect(page).to have_content('Revoked')
      expect(page).not_to have_button('Revoke')
    end
  end
end
