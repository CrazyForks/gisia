# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectLabelPolicy, type: :policy do
  let_it_be(:owner) { create(:user) }
  let_it_be(:project) { create(:project, creator: owner, parent_namespace: owner.namespace) }
  let_it_be(:label) { create(:label, namespace: project.namespace) }
  let_it_be(:guest) { create(:user) }
  let_it_be(:reporter) { create(:user) }
  let_it_be(:non_member) { create(:user) }

  before_all do
    create(:project_member, user: guest, project: project, access_level: :guest)
    create(:project_member, user: reporter, project: project, access_level: :reporter)
  end

  describe 'non-member' do
    subject(:policy) { described_class.new(non_member, label) }

    it { expect(policy.allowed?(:read_label)).to be(false) }
    it { expect(policy.allowed?(:admin_label)).to be(false) }
  end

  describe 'guest member' do
    subject(:policy) { described_class.new(guest, label) }

    it { expect(policy.allowed?(:read_label)).to be(true) }
    it { expect(policy.allowed?(:admin_label)).to be(false) }
  end

  describe 'reporter member' do
    subject(:policy) { described_class.new(reporter, label) }

    it { expect(policy.allowed?(:read_label)).to be(true) }
    it { expect(policy.allowed?(:admin_label)).to be(true) }
  end
end
