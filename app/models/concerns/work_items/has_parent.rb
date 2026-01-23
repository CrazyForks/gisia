# frozen_string_literal: true

module WorkItems
  module HasParent
    extend ActiveSupport::Concern

    included do
      belongs_to :parent, class_name: 'WorkItem', optional: true
      has_many :children, class_name: 'WorkItem', foreign_key: 'parent_id', dependent: :nullify

      validate :validate_parent_type, if: :parent_id_changed?
      validate :validate_same_namespace, if: :parent_id_changed?
      validate :validate_parent_not_allowed_on_create, on: :create
      validate :validate_no_cyclic_reference, if: :parent_id_changed?

      after_save :validate_no_cyclic_reference, if: :saved_change_to_parent_id?
    end

    private

    def validate_parent_type
      return if parent.blank?
      return if parent.epic?

      errors.add(:parent, 'must be an Epic')
    end

    def validate_same_namespace
      return if parent.blank?
      return if parent.namespace_id == namespace_id

      errors.add(:parent, 'must be in the same project')
    end

    def validate_parent_not_allowed_on_create
      errors.add(:parent, 'cannot be set when creating') if parent_id.present?
    end

    def validate_no_cyclic_reference
      return if parent.blank?
      return if parent_id != id && !hierarchy.cyclic?

      errors.add(:parent, 'would create a cyclic relationship')
      raise ActiveRecord::Rollback if saved_change_to_parent_id?
    end

    def hierarchy
      Gitlab::WorkItems::WorkItemHierarchy.new(WorkItem.where(id: id), WorkItem.where(id: parent_id))
    end
  end
end
