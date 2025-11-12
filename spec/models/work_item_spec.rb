require 'rails_helper'

RSpec.describe WorkItem, type: :model do
  subject(:work_item) { described_class.new }

  describe 'associations' do
    it { should belong_to(:namespace) }
  end

  describe 'state machine' do
    let(:work_item) { create(:issue) }

    describe '#close' do
      it 'updates closed_at timestamp' do
        expect { work_item.close }.to change(work_item, :closed_at).from(nil)
      end

      context 'when closed by a user' do
        let(:user) { create(:user) }

        it 'sets closed_by to the user and transitions to closed state' do
          work_item.close(user)
          expect(work_item.closed_by).to eq(user)
          expect(work_item).to be_closed
        end
      end

      context 'when closed without user argument' do
        it 'does not set closed_by but transitions to closed state' do
          work_item.close
          expect(work_item.closed_by).to be_nil
          expect(work_item).to be_closed
        end
      end

      context 'with workflow labels' do
        let(:project) { create(:project, workflows: 'workflow::, status::') }
        let(:work_item) { create(:issue, namespace: project.namespace) }
        let(:workflow_label) { create(:label, namespace: project.namespace, title: 'workflow::dev') }
        let(:status_label) { create(:label, namespace: project.namespace, title: 'status::todo') }
        let(:other_label) { create(:label, namespace: project.namespace, title: 'priority::high') }

        before do
          work_item.labels << [workflow_label, status_label, other_label]
        end

        it 'removes workflow-scoped labels when closing' do
          expect(work_item.labels).to include(workflow_label, status_label, other_label)

          work_item.close

          work_item.reload
          expect(work_item.labels).not_to include(workflow_label, status_label)
          expect(work_item.labels).to include(other_label)
        end

        context 'when project workflows are blank' do
          let(:project) { create(:project, workflows: '') }

          it 'does not remove any labels when closing' do
            expect(work_item.labels).to include(workflow_label, status_label, other_label)

            work_item.close

            work_item.reload
            expect(work_item.labels).to include(workflow_label, status_label, other_label)
          end
        end
      end
    end
  end
end
