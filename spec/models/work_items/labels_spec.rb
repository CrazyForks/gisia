require 'rails_helper'

RSpec.describe WorkItems::HasLabels, type: :model do
  subject(:work_item) { create(:issue, namespace: namespace) }

  let(:namespace) { create(:namespace) }

  describe '#relink_label_ids' do
    context 'has one regular label, add one scoped label' do
      let(:regular_label) { create(:label, namespace: namespace, title: 'urgent') }
      let(:scoped_label) { create(:label, namespace: namespace, title: 'workflow::todo') }

      before do
        work_item.labels << regular_label
      end

      it 'has both labels' do
        work_item.relink_label_ids([scoped_label.id])

        expect(work_item.label_ids).to match_array([regular_label.id, scoped_label.id])
      end
    end

    context 'has one scoped label, add a new one with the same scope' do
      let(:old_label) { create(:label, namespace: namespace, title: 'workflow::todo') }
      let(:new_label) { create(:label, namespace: namespace, title: 'workflow::working_on') }

      before do
        work_item.labels << old_label
      end

      it 'removes old scoped label and adds new one' do
        work_item.relink_label_ids([new_label.id])

        expect(work_item.label_ids).to eq([new_label.id])
        expect(work_item.label_ids).not_to include(old_label.id)
      end
    end

    context 'do not have labels, add two scoped labels with the same scope' do
      let(:label_1) { create(:label, namespace: namespace, title: 'workflow::todo') }
      let(:label_2) { create(:label, namespace: namespace, title: 'workflow::working_on') }

      it 'raises error' do
        expect { work_item.label_ids = [label_1.id, label_2.id] }.to raise_error(ActiveRecord::RecordNotSaved)
      end
    end

    context 'has one scoped label, add two new different scoped labels with different scopes' do
      let(:existing_label) { create(:label, namespace: namespace, title: 'workflow::todo') }
      let(:status_label) { create(:label, namespace: namespace, title: 'status::done') }
      let(:priority_label) { create(:label, namespace: namespace, title: 'priority::high') }

      before do
        work_item.labels << existing_label
      end

      it 'has all three labels' do
        work_item.relink_label_ids([status_label.id, priority_label.id])

        expect(work_item.label_ids).to match_array([existing_label.id, status_label.id, priority_label.id])
      end
    end

    context 'has one scoped label, relink with existing and new label with same scope' do
      let(:old_label) { create(:label, namespace: namespace, title: 'workflow::todo') }
      let(:new_label) { create(:label, namespace: namespace, title: 'workflow::working_on') }

      before do
        work_item.labels << old_label
      end

      it 'has only the new label' do
        work_item.relink_label_ids([old_label.id, new_label.id])

        expect(work_item.label_ids).to eq([new_label.id])
        expect(work_item.label_ids).not_to include(old_label.id)
      end

      context 'has another regular label' do
        let(:regular_label) { create(:label, namespace: namespace, title: 'regular') }
        before do
          work_item.labels << regular_label
        end

        it 'has only the new label' do
          work_item.relink_label_ids([old_label.id, new_label.id, regular_label.id])

          expect(work_item.label_ids).to match_array([new_label.id, regular_label.id])
          expect(work_item.label_ids).not_to include(old_label.id)
        end
      end
    end
  end
end
