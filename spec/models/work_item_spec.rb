require 'rails_helper'

RSpec.describe WorkItem, type: :model do
  subject(:work_item) { described_class.new }

  describe 'associations' do
    it { should belong_to(:namespace) }
  end

  describe 'state machine' do
    let(:work_item) { create(:work_item) }

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
    end
  end
end
