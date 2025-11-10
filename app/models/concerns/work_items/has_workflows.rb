# frozen_string_literal: true

module WorkItems
  module HasWorkflows
    extend ActiveSupport::Concern

    included do
      state_machine :state_id do
        before_transition any => :closed do |work_item|
          work_item.remove_workflow_scoped_labels
        end
      end
    end

    def remove_workflow_scoped_labels
      # Todo, only for project now
      return if project.blank? || project.workflows.blank?

      workflow_prefixes = project.workflows.split(',').map(&:strip).reject(&:blank?)
      return if workflow_prefixes.empty?

      matching_labels = Label.where(namespace_id: project.namespace_id).with_scopes(workflow_prefixes)
      label_links.where(label_id: matching_labels).destroy_all
    end
  end
end
