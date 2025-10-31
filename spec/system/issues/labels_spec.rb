require 'rails_helper'

RSpec.describe 'Issue Labels', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'label management on issue show page' do
    let!(:label1) { create(:label, namespace: project.namespace, title: 'Bug') }
    let!(:label2) { create(:label, namespace: project.namespace, title: 'Feature') }
    let!(:issue) { create(:issue, author: user, namespace: project.namespace, title: 'Issue to Test Labels') }

    it 'allows adding a single label on show page and persists after refresh' do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).not_to have_content('Bug')

      all_buttons = page.all('button')
      labels_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
      labels_edit_button.click

      fill_in 'Search labels...', with: 'Bug'
      expect(page).to have_css("#droplist_label_#{label1.id}")
      page.find("#droplist_label_#{label1.id}").click

      expect(page).to have_content('Bug')

      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_content('Bug')
    end

    it 'allows adding multiple labels on show page and persists after refresh' do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      all_buttons = page.all('button')
      labels_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
      labels_edit_button.click

      fill_in 'Search labels...', with: 'Bug'
      expect(page).to have_css("#droplist_label_#{label1.id}")
      page.find("#droplist_label_#{label1.id}").click

      expect(page).not_to have_field('Search labels...')

      all_buttons = page.all('button')
      labels_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
      labels_edit_button.click

      fill_in 'Search labels...', with: 'Feature'
      expect(page).to have_css("#droplist_label_#{label2.id}")
      page.find("#droplist_label_#{label2.id}").click

      expect(page).to have_content('Bug')
      expect(page).to have_content('Feature')

      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_content('Bug')
      expect(page).to have_content('Feature')
    end

    it 'allows removing a label on show page and persists after refresh' do
      issue.update!(label_ids: [label1.id, label2.id])
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).to have_content('Bug')
      expect(page).to have_content('Feature')

      all_buttons = page.all('button')
      labels_edit_button = all_buttons.select { |btn| btn.text == 'Edit' }.last
      labels_edit_button.click

      fill_in 'Search labels...', with: 'Bug'
      expect(page).to have_css("#droplist_label_#{label1.id}")
      page.find("#droplist_label_#{label1.id}").click

      expect(page).not_to have_content('Bug')
      expect(page).to have_content('Feature')

      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      expect(page).not_to have_content('Bug')
      expect(page).to have_content('Feature')
    end
  end

  describe 'label search filtering' do
    let!(:label_aaa) { create(:label, namespace: project.namespace, title: 'aaa') }
    let!(:label_bbb) { create(:label, namespace: project.namespace, title: 'bbb') }
    let!(:label_ccc) { create(:label, namespace: project.namespace, title: 'ccc') }
    let!(:issue_with_no_labels) { create(:issue, author: user, namespace: project.namespace, title: 'issue with no labels') }
    let!(:issue_with_one_label) { create(:issue, author: user, namespace: project.namespace, title: 'issue with 1 label: aaa', label_ids: [label_aaa.id]) }
    let!(:issue_with_two_labels) { create(:issue, author: user, namespace: project.namespace, title: 'issue with 2 labels: aaa, bbb', label_ids: [label_aaa.id, label_bbb.id]) }
    let!(:issue_with_three_labels) { create(:issue, author: user, namespace: project.namespace, title: 'issue with 3 labels: aaa, bbb, ccc', label_ids: [label_aaa.id, label_bbb.id, label_ccc.id]) }

    it 'filters by single label (AND logic with one label)' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path, labels: 'aaa')

      expect(page).not_to have_content('issue with no labels')
      expect(page).to have_content('issue with 1 label: aaa')
      expect(page).to have_content('issue with 2 labels: aaa, bbb')
      expect(page).to have_content('issue with 3 labels: aaa, bbb, ccc')
    end

    it 'filters by two labels with comma (AND logic - all labels must match)' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path, labels: 'aaa,bbb')

      expect(page).not_to have_content('issue with 1 label: aaa')
      expect(page).to have_content('issue with 2 labels: aaa, bbb')
      expect(page).to have_content('issue with 3 labels: aaa, bbb, ccc')
    end

    it 'filters by two labels with pipe (OR logic - any label matches)' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path, labels: 'bbb|ccc')

      expect(page).not_to have_content('issue with 1 label: aaa')
      expect(page).to have_content('issue with 2 labels: aaa, bbb')
      expect(page).to have_content('issue with 3 labels: aaa, bbb, ccc')
    end

    it 'searches by label and title at the same time' do
      visit namespace_project_issues_path(project.namespace.parent.full_path, project.path, search: 'issue with 3', labels: 'aaa,bbb')

      expect(page).not_to have_content('issue with 1 label: aaa')
      expect(page).not_to have_content('issue with 2 labels: aaa, bbb')
      expect(page).to have_content('issue with 3 labels: aaa, bbb, ccc')
    end
  end
end

