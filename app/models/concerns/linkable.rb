# frozen_string_literal: true

module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :item_link_records, class_name: 'ItemLink', as: :source, dependent: :destroy
    has_many :item_link_records_as_target, class_name: 'ItemLink', as: :target, dependent: :destroy
  end

  def item_links
    item_link_records.map(&:target)
  end
end
