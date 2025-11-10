# frozen_string_literal: true

class WorkflowsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    items = value.split(',').map(&:strip).reject(&:blank?)

    items.each do |item|
      unless item.end_with?('::')
        record.errors.add(attribute, "each workflow must end with '::' (e.g., 'workflow::')")
        break
      end
    end
  end
end
