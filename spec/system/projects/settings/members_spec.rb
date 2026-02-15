require 'rails_helper'

describe 'Members Settings', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'index' do
    it 'displays the members list with the owner' do
      visit namespace_project_settings_members_path(project.namespace.parent.full_path, project.namespace.path)

      expect(page).to have_content(user.name)
      expect(page).to have_content("@#{user.username}")
      expect(page).to have_content('Owner')
    end
  end

  describe 'create and edit members' do
    let_it_be(:other_user) { create(:user, password: password, password_confirmation: password) }

    it 'adds a new member and edits their role' do
      visit namespace_project_settings_members_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'Add Member'
      expect(page).to have_select('member_user_id')

      select "#{other_user.name} (@#{other_user.username})", from: 'member_user_id'
      select 'Developer', from: 'member_access_level'
      click_button 'Add Member'

      expect(page).to have_content(other_user.name)
      expect(page).to have_content('Developer')

      member = project.namespace.members.find_by(user: other_user)
      find("#edit-member-#{member.id}").click

      expect(page).to have_content("#{other_user.name} (@#{other_user.username})")
      expect(page).to have_button('Update Member')
      expect(page).not_to have_button('Add Member')

      select 'Maintainer', from: 'project_member_access_level'
      click_button 'Update Member'

      expect(page).to have_content('Maintainer')
      expect(page).to have_button('Add Member')
    end
  end

  describe 'delete members' do
    let_it_be(:member_user) { create(:user, password: password, password_confirmation: password) }

    it 'removes a member from the project' do
      create(:project_member, user: member_user, project: project, access_level: :reporter)

      visit namespace_project_settings_members_path(project.namespace.parent.full_path, project.namespace.path)

      expect(page).to have_content(member_user.name)

      member = project.namespace.members.find_by(user: member_user)

      page.accept_confirm do
        find("#delete-member-#{member.id}").click
      end

      expect(page).not_to have_content(member_user.name)
      expect(page).to have_content(user.name)
    end
  end

  describe 'cancel member form' do
    it 'clicks Add Member then Cancel to return to the list' do
      visit namespace_project_settings_members_path(project.namespace.parent.full_path, project.namespace.path)

      click_button 'Add Member'
      expect(page).to have_select('member_user_id')

      click_link 'Cancel'

      expect(page).to have_button('Add Member')
      expect(page).to have_content(user.name)
    end
  end
end
