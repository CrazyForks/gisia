require 'rails_helper'

RSpec.describe User, type: :model do
  let_it_be(:user, freeze: true) { create(:user) }

  describe 'associations' do
    it 'creates a user namespace automatically' do
      expect(user.namespace).to be_present
      expect(user.namespace).to be_a(Namespaces::UserNamespace)
    end
  end
end
