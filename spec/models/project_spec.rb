require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'HasProtectedRefs concern' do
    subject(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

    let_it_be(:user) { create(:user) }

    describe '#create_default_protected_branch' do
      it 'creates a protected branch for the default branch' do
        expect(project.protected_branches.count).to eq(1)
      end

      it 'sets the correct attributes on the protected branch' do
        branch = project.protected_branches.first
        expect(branch.name).to eq('main')
        expect(branch.access_level).to eq('maintainer')
        expect(branch.allow_push).to be(true)
        expect(branch.allow_force_push).to be(false)
        expect(branch.allow_merge_to).to be(true)
      end

      it 'does not create a duplicate protected branch' do
        project.create_default_protected_branch
        expect(project.protected_branches.count).to eq(1)
      end
    end
  end

  describe '#organization' do
    subject(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

    let_it_be(:user) { create(:user) }

    it 'returns nil' do
      expect(project.organization).to be_nil
    end
  end

  describe 'HasBoard concern' do
    subject(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

    let_it_be(:user) { create(:user) }

    describe 'creating a new project' do
      it 'creates a default board with three stages' do
        expect(project.board).to be_present
        expect(project.board.stages.count).to eq(3)
      end

      it 'creates three default stages with correct titles and kinds' do
        stages = project.board.stages.ordered
        expect(stages[0].title).to eq('Todo')
        expect(stages[0].kind).to eq('opened')
        expect(stages[1].title).to eq('Working On')
        expect(stages[1].kind).to eq('opened')
        expect(stages[2].title).to eq('Closed')
        expect(stages[2].kind).to eq('closed')
      end

      it 'creates two default workflow labels in the namespace' do
        workflow_labels = project.namespace.labels.where('title LIKE ?', 'workflow::%')
        expect(workflow_labels.count).to eq(2)
        expect(workflow_labels.pluck(:title).sort).to eq(['workflow::todo', 'workflow::working_on'])
      end

      it 'associates workflow labels with the correct stages' do
        todo_stage = project.board.stages.find_by(title: 'Todo')
        working_on_stage = project.board.stages.find_by(title: 'Working On')
        closed_stage = project.board.stages.find_by(title: 'Closed')

        todo_label = project.namespace.labels.find_by(title: 'workflow::todo')
        working_on_label = project.namespace.labels.find_by(title: 'workflow::working_on')

        expect(todo_stage.label_ids).to include(todo_label.id)
        expect(working_on_stage.label_ids).to include(working_on_label.id)
        expect(closed_stage.label_ids).to be_empty
      end
    end
  end
end
