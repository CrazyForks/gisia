require 'rails_helper'

RSpec.describe WorkItems::HasLabels, type: :model do
  subject(:work_item) { create(:work_item, namespace: namespace) }

  let(:namespace) { create(:namespace) }

  describe '#remove_duplicate_scoped_labels' do
    context 'when adding scoped label to work item with regular label' do
      let(:regular_label) { create(:label, namespace: namespace, title: 'urgent') }
      let(:scoped_label) { create(:label, namespace: namespace, title: 'workflow::todo') }

      before do
        work_item.labels << regular_label
      end

      it 'keeps both labels' do
        work_item.label_ids = [regular_label.id, scoped_label.id]
        work_item.valid?

        expect(work_item.label_ids).to match_array([regular_label.id, scoped_label.id])
      end
    end

    context 'when adding scoped label to work item with same scope label' do
      let(:old_label) { create(:label, namespace: namespace, title: 'workflow::todo') }
      let(:new_label) { create(:label, namespace: namespace, title: 'workflow::working_on') }

      before do
        work_item.labels << old_label
      end

      it 'removes old label and keeps new one' do
        work_item.label_ids = [new_label.id]
        work_item.valid?

        expect(work_item.label_ids).to eq([new_label.id])
        expect(work_item.label_ids).not_to include(old_label.id)
      end
    end

    context 'when adding scoped label to work item with different scope label' do
      let(:workflow_label) { create(:label, namespace: namespace, title: 'workflow::todo') }
      let(:status_label) { create(:label, namespace: namespace, title: 'status::working_on') }

      before do
        work_item.labels << workflow_label
      end

      it 'keeps both labels' do
        work_item.label_ids = [workflow_label.id, status_label.id]
        work_item.valid?

        expect(work_item.label_ids).to match_array([workflow_label.id, status_label.id])
      end
    end
  end

  describe '#validate_scoped_labels_uniqueness' do
    context 'when there are two labels with same scope' do
      let(:label_1) { create(:label, namespace: namespace, title: 'workflow::todo') }
      let(:label_2) { create(:label, namespace: namespace, title: 'workflow::working_on') }

      it 'adds validation error' do
        work_item.label_ids = [label_1.id, label_2.id]
        work_item.valid?

        expect(work_item.errors[:labels]).to include("can only have one label per scope: workflow")
      end
    end
  end
end
