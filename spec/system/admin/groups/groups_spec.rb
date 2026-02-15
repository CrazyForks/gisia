require 'rails_helper'

RSpec.describe 'Admin Groups Management', type: :system do
  let_it_be(:password) { 'password123' }
  let_it_be(:admin) { create(:user, password: password, password_confirmation: password, admin: true) }

  before do
    gisia_sign_in(admin, password: password)
  end

  describe 'edit' do
    let(:group) { create(:group, name: 'My Group', path: 'my-group', creator: admin) }

    it 'displays the edit form with editable path field' do
      visit edit_admin_group_path(group)

      expect(page).to have_field('Group name', with: 'My Group')
      expect(page).to have_field('Group path', with: 'my-group')
      expect(page).not_to have_field('Group path', disabled: true)
      expect(page).not_to have_field('Group path', readonly: true)
    end

    it 'updates the group path' do
      visit edit_admin_group_path(group)

      fill_in 'Group path', with: 'updated-group-path'
      click_button 'Update Group'

      expect(page).to have_content('Group was successfully updated.')
      group.reload
      expect(group.path).to eq('updated-group-path')
    end
  end
end
