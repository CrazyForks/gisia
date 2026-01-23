# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkItems::HasParent do
  let_it_be(:namespace) { create(:namespace) }
  let_it_be(:other_namespace) { create(:namespace) }

  describe 'associations' do
    it 'has parent association' do
      expect(WorkItem.reflect_on_association(:parent).macro).to eq(:belongs_to)
      expect(WorkItem.reflect_on_association(:parent).options[:class_name]).to eq('WorkItem')
      expect(WorkItem.reflect_on_association(:parent).options[:optional]).to be true
    end

    it 'has children association' do
      expect(WorkItem.reflect_on_association(:children).macro).to eq(:has_many)
      expect(WorkItem.reflect_on_association(:children).options[:class_name]).to eq('WorkItem')
      expect(WorkItem.reflect_on_association(:children).options[:foreign_key]).to eq('parent_id')
      expect(WorkItem.reflect_on_association(:children).options[:dependent]).to eq(:nullify)
    end
  end

  describe 'parent not allowed on create' do
    let(:parent_epic) { create(:epic, namespace: namespace) }

    it 'is invalid when issue is created with parent' do
      issue = build(:issue, namespace: namespace, parent: parent_epic)
      expect(issue).not_to be_valid
      expect(issue.errors[:parent]).to include('cannot be set when creating')
    end

    it 'is invalid when epic is created with parent' do
      epic = build(:epic, namespace: namespace, parent: parent_epic)
      expect(epic).not_to be_valid
      expect(epic.errors[:parent]).to include('cannot be set when creating')
    end
  end

  describe 'parent type validation' do
    context 'when issue has an epic parent' do
      let(:issue) { create(:issue, namespace: namespace) }
      let(:parent_epic) { create(:epic, namespace: namespace) }

      it 'is valid' do
        issue.parent = parent_epic
        expect(issue).to be_valid
      end
    end

    context 'when issue has an issue parent' do
      let(:issue) { create(:issue, namespace: namespace) }
      let(:parent_issue) { create(:issue, namespace: namespace) }

      it 'is invalid' do
        issue.parent_id = parent_issue.id
        expect(issue).not_to be_valid
        expect(issue.errors[:parent]).to include('must be an Epic')
      end
    end

    context 'when epic has an epic parent' do
      let(:epic) { create(:epic, namespace: namespace) }
      let(:parent_epic) { create(:epic, namespace: namespace) }

      it 'is valid' do
        epic.parent = parent_epic
        expect(epic).to be_valid
      end
    end

    context 'when epic has an issue parent' do
      let(:epic) { create(:epic, namespace: namespace) }
      let(:parent_issue) { create(:issue, namespace: namespace) }

      it 'is invalid' do
        epic.parent_id = parent_issue.id
        expect(epic).not_to be_valid
        expect(epic.errors[:parent]).to include('must be an Epic')
      end
    end

    context 'when work item has no parent' do
      it 'issue without parent is valid' do
        issue = build(:issue, namespace: namespace, parent: nil)
        expect(issue).to be_valid
      end

      it 'epic without parent is valid' do
        epic = build(:epic, namespace: namespace, parent: nil)
        expect(epic).to be_valid
      end
    end
  end

  describe 'same namespace validation' do
    context 'when parent is in same namespace' do
      let(:issue) { create(:issue, namespace: namespace) }
      let(:parent_epic) { create(:epic, namespace: namespace) }

      it 'is valid' do
        issue.parent = parent_epic
        expect(issue).to be_valid
      end
    end

    context 'when parent is in different namespace' do
      let(:issue) { create(:issue, namespace: namespace) }
      let(:parent_epic) { create(:epic, namespace: other_namespace) }

      it 'is invalid' do
        issue.parent = parent_epic
        expect(issue).not_to be_valid
        expect(issue.errors[:parent]).to include('must be in the same project')
      end
    end
  end

  describe 'cyclic reference validation' do
    context 'when epic references itself' do
      let(:epic) { create(:epic, namespace: namespace) }

      it 'is invalid' do
        epic.parent = epic
        expect(epic).not_to be_valid
        expect(epic.errors[:parent]).to include('would create a cyclic relationship')
      end
    end

    context 'when creating a simple cycle (A -> B -> A)' do
      let(:epic_a) { create(:epic, namespace: namespace) }
      let(:epic_b) { create(:epic, namespace: namespace).tap { |e| e.update!(parent: epic_a) } }

      it 'is invalid' do
        epic_a.parent = epic_b
        expect(epic_a).not_to be_valid
        expect(epic_a.errors[:parent]).to include('would create a cyclic relationship')
      end
    end

    context 'when creating a deep cycle (A -> B -> C -> A)' do
      let(:epic_a) { create(:epic, namespace: namespace) }
      let(:epic_b) { create(:epic, namespace: namespace).tap { |e| e.update!(parent: epic_a) } }
      let(:epic_c) { create(:epic, namespace: namespace).tap { |e| e.update!(parent: epic_b) } }

      it 'is invalid' do
        epic_a.parent = epic_c
        expect(epic_a).not_to be_valid
        expect(epic_a.errors[:parent]).to include('would create a cyclic relationship')
      end
    end

    context 'when no cycle exists' do
      let(:epic_a) { create(:epic, namespace: namespace) }
      let(:epic_b) { create(:epic, namespace: namespace) }

      it 'allows the update' do
        epic_b.update!(parent: epic_a)
        expect(epic_b.reload.parent).to eq(epic_a)
      end
    end
  end

  describe 'dependent nullify' do
    let(:parent_epic) { create(:epic, namespace: namespace) }
    let!(:child_issue) { create(:issue, namespace: namespace).tap { |i| i.update!(parent: parent_epic) } }
    let!(:child_epic) { create(:epic, namespace: namespace).tap { |e| e.update!(parent: parent_epic) } }

    it 'nullifies children parent_id when parent is deleted' do
      parent_epic.destroy!

      expect(child_issue.reload.parent_id).to be_nil
      expect(child_epic.reload.parent_id).to be_nil
    end
  end
end
