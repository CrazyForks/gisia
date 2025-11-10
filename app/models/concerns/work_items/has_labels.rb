# frozen_string_literal: true

module WorkItems
  module HasLabels
    extend ActiveSupport::Concern

    def relink_label_ids(extra_label_ids)
      return if extra_label_ids.blank?

      old_label_ids = label_links.pluck(:label_id)
      new_labels = labels_in_namespace(extra_label_ids)
      new_scopes = scoped_labels_by_scope(new_labels).keys

      ids_to_remove = []
      if old_label_ids.present? && new_scopes.present?
        old_labels = labels_in_namespace(old_label_ids)
        new_scopes.each do |scope|
          old_scoped = old_scoped_labels(old_labels, scope).map(&:id)
          ids_to_remove.concat(old_scoped)
        end
      end

      merged_ids = (old_label_ids | extra_label_ids) - ids_to_remove
      self.label_ids = merged_ids
    end

    private

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
