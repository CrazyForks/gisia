# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuePolicy, type: :policy do
  let_it_be(:owner) { create(:user) }
  let_it_be(:project) { create(:project, creator: owner, parent_namespace: owner.namespace) }
  let_it_be(:issue) { create(:issue, namespace: project.namespace, author: owner) }
  let_it_be(:non_member) { create(:user) }
  let_it_be(:guest) { create(:user) }
  let_it_be(:planner) { create(:user) }
  let_it_be(:reporter) { create(:user) }

  before_all do
    create(:project_member, user: guest, project: project, access_level: :guest)
    create(:project_member, user: planner, project: project, access_level: :planner)
    create(:project_member, user: reporter, project: project, access_level: :reporter)
  end

  describe 'non-member on private project' do
    subject(:policy) { described_class.new(non_member, issue) }

    it { expect(policy.allowed?(:read_issue)).to be(false) }
    it { expect(policy.allowed?(:create_issue)).to be(false) }
    it { expect(policy.allowed?(:update_issue)).to be(false) }
    it { expect(policy.allowed?(:destroy_issue)).to be(false) }
  end

  describe 'guest member' do
    subject(:policy) { described_class.new(guest, issue) }

    it { expect(policy.allowed?(:read_issue)).to be(true) }
    it { expect(policy.allowed?(:create_issue)).to be(true) }
    it { expect(policy.allowed?(:update_issue)).to be(false) }
    it { expect(policy.allowed?(:destroy_issue)).to be(false) }
  end

  describe 'planner member' do
    subject(:policy) { described_class.new(planner, issue) }

    it { expect(policy.allowed?(:read_issue)).to be(true) }
    it { expect(policy.allowed?(:create_issue)).to be(true) }
    it { expect(policy.allowed?(:update_issue)).to be(true) }
    it { expect(policy.allowed?(:destroy_issue)).to be(true) }
  end

  describe 'reporter member' do
    subject(:policy) { described_class.new(reporter, issue) }

    it { expect(policy.allowed?(:read_issue)).to be(true) }
    it { expect(policy.allowed?(:create_issue)).to be(true) }
    it { expect(policy.allowed?(:update_issue)).to be(true) }
    it { expect(policy.allowed?(:destroy_issue)).to be(false) }
  end

  describe 'confidential issue' do
    let_it_be(:confidential_issue) { create(:issue, :confidential, namespace: project.namespace, author: owner) }

    it 'prevents guest non-author from reading' do
      policy = described_class.new(guest, confidential_issue)
      expect(policy.allowed?(:read_issue)).to be(false)
    end

    it 'allows planner to read' do
      policy = described_class.new(planner, confidential_issue)
      expect(policy.allowed?(:read_issue)).to be(true)
    end

    it 'allows reporter to read' do
      policy = described_class.new(reporter, confidential_issue)
      expect(policy.allowed?(:read_issue)).to be(true)
    end

    it 'allows author to read' do
      policy = described_class.new(owner, confidential_issue)
      expect(policy.allowed?(:read_issue)).to be(true)
    end
  end
end
