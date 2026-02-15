require 'rails_helper'

RSpec.describe Namespace, type: :model do
  let_it_be(:user) { create(:user) }

  describe 'name uniqueness' do
    let_it_be(:group) { create(:group, creator: user) }
    let_it_be(:existing_project) { create(:project, name: 'test-project', path: 'test-project', creator: user, parent_namespace: group.namespace) }

    it 'prevents creating a project namespace with duplicate name under same parent' do
      project = Project.new(name: 'test-project', path: 'test-project-2', creator_id: user.id, namespace_parent_id: group.namespace.id)
      project.build_namespace
      project.namespace.creator_id = user.id

      expect(project).not_to be_valid
      expect(project.namespace.errors[:name]).to include('has already been taken')
    end

    it 'prevents creating a project namespace with duplicate name in different case' do
      project = Project.new(name: 'Test-Project', path: 'test-project-3', creator_id: user.id, namespace_parent_id: group.namespace.id)
      project.build_namespace
      project.namespace.creator_id = user.id

      expect(project).not_to be_valid
      expect(project.namespace.errors[:name]).to include('has already been taken')
    end

    it 'allows creating a project namespace with same name under different parent' do
      project = Project.new(name: 'test-project', path: 'test-project', creator_id: user.id, namespace_parent_id: user.namespace.id)
      project.build_namespace
      project.namespace.creator_id = user.id

      expect(project).to be_valid
    end
  end
end
