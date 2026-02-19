require 'rails_helper'

RSpec.describe ProjectPolicy, type: :policy do
  let_it_be(:user) { create(:user) }
  let_it_be(:project) { create(:project, creator: user, parent_namespace: user.namespace) }

  subject(:policy) { described_class.new(user, project) }

  describe 'organization_owner condition' do
    it 'is false because project has no organization' do
      expect(policy.send(:organization_owner?)).to be(false)
    end
  end

  describe 'read_all_organization_resources ability' do
    context 'for a regular project member' do
      it 'is not allowed' do
        expect(policy.allowed?(:read_all_organization_resources)).to be(false)
      end
    end
  end
end
