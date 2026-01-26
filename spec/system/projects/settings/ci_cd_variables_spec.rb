# frozen_string_literal: true

require 'rails_helper'

describe 'CI/CD Variables Settings', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'add variable' do
    it 'creates a new variable and shows it in the list' do
      visit edit_namespace_project_settings_ci_cd_path(project.namespace.parent.full_path, project.namespace.path)

      find('h2', text: 'Variables').ancestor('.cursor-pointer').click

      expect(page).to have_content('No variables defined')

      click_button 'Add your first variable'

      fill_in 'variable_key', with: 'MY_SECRET_KEY'
      fill_in 'variable_value', with: 'my_secret_value'

      click_button 'Add variable'

      expect(page).to have_content('MY_SECRET_KEY')
      expect(page).not_to have_content('No variables defined')
    end
  end
end
