# frozen_string_literal: true

module WorkItems
  module HasLabels
    extend ActiveSupport::Concern

    included do
      before_validation :remove_duplicate_scoped_labels
      validate :validate_scoped_labels_uniqueness
    end

    def remove_duplicate_scoped_labels
      return if label_ids.blank?

      ids_to_remove = duplicate_scope_ids_to_remove
      self.label_ids = label_ids - ids_to_remove
    end

    def validate_scoped_labels_uniqueness
      return if label_ids.blank?

      new_labels_after = labels_in_namespace(label_ids)
      scoped_labels_by_scope(new_labels_after).each do |scope, labels_in_scope|
        if labels_in_scope.size > 1
          errors.add(:labels, "can only have one label per scope: #{scope}")
        end
      end
    end

    private

    def duplicate_scope_ids_to_remove
      old_label_ids = label_links.pluck(:label_id)
      return [] if old_label_ids.blank?

      old_labels_being_replaced = old_label_ids - label_ids
      return [] if old_labels_being_replaced.blank?

      new_labels = labels_in_namespace(label_ids)
      old_labels = labels_in_namespace(old_labels_being_replaced)

      ids_to_remove = []
      scoped_labels_by_scope(new_labels).each do |scope, _|
        ids_to_remove.concat(old_scoped_labels(old_labels, scope).map(&:id))
      end

      ids_to_remove
    end

    def labels_in_namespace(label_ids)
      Label.where(id: label_ids, namespace_id: namespace_id)
    end

    def scoped_labels_by_scope(labels)
      labels.select { |l| l.title.include?('::') }.group_by do |label|
        label.title.split('::').first
      end
    end

    def old_scoped_labels(old_labels, scope)
      old_labels.select { |l| l.title.start_with?("#{scope}::") }
    end
  end
end
