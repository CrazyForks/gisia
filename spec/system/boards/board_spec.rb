require 'rails_helper'

RSpec.describe 'Board Management', type: :system, js: true do
  def html5_drag(from, to)
    work_item_id = from['data-work-item-id']
    to_stage_id = to['id'].match(/\d+$/).to_s

    page.execute_script(<<~JS)
      const sourceNode = document.querySelector('[data-work-item-id="#{work_item_id}"]');
      const destinationNode = document.querySelector('[data-stage-id="#{to_stage_id}"]');

      sourceNode.classList.add('opacity-50');

      const dataTransfer = new DataTransfer();
      const dropEvent = new DragEvent('drop', {
        bubbles: true,
        cancelable: true,
        dataTransfer,
        view: window
      });
      destinationNode.dispatchEvent(dropEvent);

      sourceNode.classList.remove('opacity-50');
    JS
  end
  let_it_be(:password) { 'password123' }
  let_it_be(:user) { create(:user, password: password, password_confirmation: password) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }
  let_it_be(:board) do
    board = Board.create!(namespace: project.namespace, updated_by: user)
    BoardStage.create!(board: board, title: 'Todo', kind: :opened, rank: 0)
    BoardStage.create!(board: board, title: 'Working On', kind: :opened, rank: 1)
    BoardStage.create!(board: board, title: 'Closed', kind: :closed, rank: 2)
    board
  end

  before do
    gisia_sign_in(user, password: password)
  end

  describe 'creating a new board stage' do
    it 'keeps the closed stage on the same row' do
      visit namespace_project_boards_path(project.namespace.parent.full_path, project.path)

      click_button id: 'add-stage-button'

      new_stage_y = find('turbo-frame div.bg-green-50').evaluate_script('this.closest("turbo-frame").getBoundingClientRect().top')
      closed_stage_y = find('div#closed-stage').evaluate_script('this.closest("turbo-frame").getBoundingClientRect().top')

      expect(new_stage_y).to eq(closed_stage_y)
    end
  end

  describe 'dragging issues between stages' do
    let_it_be(:issue) do
      todo_label = project.namespace.labels.find_by(title: 'workflow::todo')
      issue = create(:issue, namespace: project.namespace, title: 'Test Issue')
      issue.labels << todo_label
      issue
    end

    it 'moves issue through stages and removes workflow label when moved to closed' do
      visit namespace_project_boards_path(project.namespace.parent.full_path, project.path)

      stages = page.all('turbo-frame[id^="stage-column-"]')
      todo_stage = stages[0]
      working_on_stage = stages[1]
      closed_stage = stages[-1]

      expect(todo_stage).to have_content('Test Issue')
      expect(working_on_stage).not_to have_content('Test Issue')

      issue_card = find('[data-work-item-id]', text: 'Test Issue')
      html5_drag(issue_card, working_on_stage)

      expect(page).to have_content('Test Issue')
      sleep 1

      find('turbo-frame[id^="stage-column-"]', text: 'Test Issue', match: :first)

      issue_card = find('[data-work-item-id]', text: 'Test Issue')
      closed_stage_element = page.all('turbo-frame[id^="stage-column-"]').last
      html5_drag(issue_card, closed_stage_element)

      expect(page).to have_content('Test Issue')
      sleep 1

      expect(page.all('turbo-frame[id^="stage-column-"]').last).to have_content('Test Issue')

      issue.reload
      expect(issue.labels.pluck(:title)).not_to include('workflow::todo')
      expect(issue.closed?).to be true
    end
  end
end
