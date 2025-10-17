require 'rails_helper'

RSpec.describe 'Issue Comments', type: :system, js: true do
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }
  let_it_be(:issue) { create(:issue, author: user, namespace: project.namespace) }

  before do
    gisia_sign_in(user, password: password)
    visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)
  end

  describe 'creating root comments' do
    it 'allows creating a new comment' do
      fill_in_lexxy_editor('This is a test comment on issue', selector: "#editor-issue-#{issue.id}")
      click_button 'Comment'

      # Wait for turbo stream response
      expect(page).to have_content('This is a test comment on issue', wait: 5)
      expect(page).to have_content(user.name)
    end
  end

  describe 'creating replies' do
    let!(:root_comment) { create(:issue_note, noteable: issue, author: user, note: 'Original comment') }

    before do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)
    end

    it 'allows replying to comments' do
      within("#note_#{root_comment.id}") do
        click_button 'Reply'
      end

      fill_in_lexxy_editor('This is a reply to the comment', selector: "#editor-reply-note-#{root_comment.id}")
      within("#note-#{root_comment.id}-reply-form") do
        click_button 'Reply'
      end

      expect(page).to have_content('This is a reply to the comment', wait: 5)
    end

    it 'shows replies count when there are replies' do
      create(:issue_note, noteable: issue, author: user, note: 'Reply comment', discussion_id: root_comment.id)

      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      within("#note_#{root_comment.id}") do
        expect(page).to have_content('1 replies')
      end
    end
  end

  describe 'showing/hiding replies' do
    let!(:root_comment) { create(:issue_note, noteable: issue, author: user, note: 'Original comment') }

    before do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      # Create reply through browser interaction
      within("#note_#{root_comment.id}") do
        click_button 'Reply'
      end

      fill_in_lexxy_editor('Reply comment', selector: "#editor-reply-note-#{root_comment.id}")
      within("#note-#{root_comment.id}-reply-form") do
        click_button 'Reply'
      end

      # Refresh page to verify reply count is persisted
      page.refresh

      # Wait for reply to be created and page to update
      expect(page).to have_content('1 replies', wait: 5)
    end

    it 'can toggle replies visibility' do
      within("#note_#{root_comment.id}") do
        click_button '1 replies'
      end

      expect(page).to have_content('Reply comment', wait: 5)

      within("#note_#{root_comment.id}") do
        click_button '1 replies'
      end

      expect(page).not_to have_content('Reply comment', wait: 5)
    end
  end

  describe 'editing comments' do
    let!(:comment) { create(:issue_note, noteable: issue, author: user, note: 'Original comment') }

    before do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)
    end

    it 'allows editing own comments' do
      within("#note_#{comment.id}") do
        click_button 'Edit'
      end

      expect(page).to have_content('Original comment')
    end

    it 'updates comment content after editing' do
      within("#note_#{comment.id}") do
        click_button 'Edit'
      end

      # Edit the comment content using the specific edit form editor ID
      fill_in_lexxy_editor('Updated comment content', selector: "#editor-note-#{comment.id}")
      click_button 'Save'

      expect(page).to have_content('Updated comment content', wait: 5)
      expect(page).not_to have_content('Original comment')
    end

    it 'shows edited indicator for edited comments' do
      comment.update!(last_edited_at: 1.minute.ago, updated_by: user)
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      within("#note_#{comment.id}") do
        expect(page).to have_content('(edited)')
      end
    end
  end

  describe 'deleting comments' do
    let!(:comment) { create(:issue_note, noteable: issue, author: user, note: 'Comment to delete') }

    before do
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)
    end

    it 'allows deleting own comments' do
      within("#note_#{comment.id}") do
        accept_confirm do
          click_link 'Delete'
        end
      end

      expect(page).not_to have_content('Comment to delete', wait: 5)
    end

    it 'removes replies when deleting parent comment' do
      create(:issue_note, noteable: issue, author: user, note: 'Reply to delete', discussion_id: comment.id)
      visit namespace_project_issue_path(project.namespace.parent.full_path, project.path, issue)

      within("#note_#{comment.id}") do
        accept_confirm do
          click_link 'Delete'
        end
      end

      expect(page).not_to have_content('Comment to delete', wait: 5)
      expect(page).not_to have_content('Reply to delete', wait: 5)
    end
  end

end
