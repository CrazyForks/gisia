require 'rails_helper'

RSpec.describe 'Epic Labels', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'label management on epic show page' do
    let!(:label1) { create(:label, namespace: project.namespace, title: 'Bug') }
    let!(:label2) { create(:label, namespace: project.namespace, title: 'Feature') }
    let!(:epic) { create(:epic, author: user, namespace: project.namespace, title: 'Epic to Test Labels') }

    it 'allows adding a single label on show page and persists after refresh' do
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).not_to have_content('Bug')

      click_button 'labels-edit-button'

      fill_in 'Search labels...', with: 'Bug'
      expect(page).to have_css("#droplist_label_#{label1.id}")
      page.find("#droplist_label_#{label1.id}").click

      expect(page).to have_content('Bug')

      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_content('Bug')
    end

    it 'allows adding multiple labels on show page and persists after refresh' do
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      click_button 'labels-edit-button'

      fill_in 'Search labels...', with: 'Bug'
      expect(page).to have_css("#droplist_label_#{label1.id}")
      page.find("#droplist_label_#{label1.id}").click

      expect(page).not_to have_field('Search labels...')

      click_button 'labels-edit-button'

      fill_in 'Search labels...', with: 'Feature'
      expect(page).to have_css("#droplist_label_#{label2.id}")
      page.find("#droplist_label_#{label2.id}").click

      expect(page).to have_content('Bug')
      expect(page).to have_content('Feature')

      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_content('Bug')
      expect(page).to have_content('Feature')
    end

    it 'allows removing a label on show page and persists after refresh' do
      epic.update!(label_ids: [label1.id, label2.id])
      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).to have_content('Bug')
      expect(page).to have_content('Feature')

      click_button 'labels-edit-button'

      fill_in 'Search labels...', with: 'Bug'
      expect(page).to have_css("#droplist_label_#{label1.id}")
      page.find("#droplist_label_#{label1.id}").click

      expect(page).not_to have_content('Bug')
      expect(page).to have_content('Feature')

      visit namespace_project_epic_path(project.namespace.parent.full_path, project.path, epic)

      expect(page).not_to have_content('Bug')
      expect(page).to have_content('Feature')
    end
  end

  describe 'label search filtering' do
    let!(:label_aaa) { create(:label, namespace: project.namespace, title: 'aaa') }
    let!(:label_bbb) { create(:label, namespace: project.namespace, title: 'bbb') }
    let!(:label_ccc) { create(:label, namespace: project.namespace, title: 'ccc') }
    let!(:epic_with_no_labels) { create(:epic, author: user, namespace: project.namespace, title: 'epic with no labels') }
    let!(:epic_with_one_label) { create(:epic, author: user, namespace: project.namespace, title: 'epic with 1 label: aaa', label_ids: [label_aaa.id]) }
    let!(:epic_with_two_labels) { create(:epic, author: user, namespace: project.namespace, title: 'epic with 2 labels: aaa, bbb', label_ids: [label_aaa.id, label_bbb.id]) }
    let!(:epic_with_three_labels) { create(:epic, author: user, namespace: project.namespace, title: 'epic with 3 labels: aaa, bbb, ccc', label_ids: [label_aaa.id, label_bbb.id, label_ccc.id]) }

    it 'filters by single label (AND logic with one label)' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path, labels: 'aaa')

      expect(page).not_to have_content('epic with no labels')
      expect(page).to have_content('epic with 1 label: aaa')
      expect(page).to have_content('epic with 2 labels: aaa, bbb')
      expect(page).to have_content('epic with 3 labels: aaa, bbb, ccc')
    end

    it 'filters by two labels with comma (AND logic - all labels must match)' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path, labels: 'aaa,bbb')

      expect(page).not_to have_content('epic with no labels')
      expect(page).not_to have_content('epic with 1 label: aaa')
      expect(page).to have_content('epic with 2 labels: aaa, bbb')
      expect(page).to have_content('epic with 3 labels: aaa, bbb, ccc')
    end

    it 'filters by two labels with pipe (OR logic - any label matches)' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path, labels: 'bbb|ccc')

      expect(page).not_to have_content('epic with no labels')
      expect(page).not_to have_content('epic with 1 label: aaa')
      expect(page).to have_content('epic with 2 labels: aaa, bbb')
      expect(page).to have_content('epic with 3 labels: aaa, bbb, ccc')
    end

    it 'searches by label and title at the same time' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path, search: 'epic with 3', labels: 'aaa,bbb')

      expect(page).not_to have_content('epic with no labels')
      expect(page).not_to have_content('epic with 1 label: aaa')
      expect(page).not_to have_content('epic with 2 labels: aaa, bbb')
      expect(page).to have_content('epic with 3 labels: aaa, bbb, ccc')
    end

    it 'clicking label on list page filters by that label' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path)

      expect(page).to have_content('epic with 1 label: aaa')
      expect(page).to have_content('epic with 2 labels: aaa, bbb')
      expect(page).to have_content('epic with 3 labels: aaa, bbb, ccc')

      click_link("epic_#{epic_with_two_labels.id}_label_#{label_bbb.id}")

      expect(page).not_to have_content('epic with no labels')
      expect(page).not_to have_content('epic with 1 label: aaa')
      expect(page).to have_content('epic with 2 labels: aaa, bbb')
      expect(page).to have_content('epic with 3 labels: aaa, bbb, ccc')
    end

    it 'clicking label on list page preserves search keyword' do
      visit namespace_project_epics_path(project.namespace.parent.full_path, project.path, search: 'epic with 2')

      expect(page).to have_content('epic with 2 labels: aaa, bbb')
      expect(page).not_to have_content('epic with 1 label: aaa')
      expect(page).not_to have_content('epic with 3 labels: aaa, bbb, ccc')

      click_link("epic_#{epic_with_two_labels.id}_label_#{label_aaa.id}")

      expect(current_url).to include('search=epic+with+2')
      expect(current_url).to include('labels=aaa')
      expect(page).to have_content('epic with 2 labels: aaa, bbb')
      expect(page).not_to have_content('epic with 1 label: aaa')
      expect(page).not_to have_content('epic with 3 labels: aaa, bbb, ccc')
    end
  end

end

