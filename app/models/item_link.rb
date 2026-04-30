# frozen_string_literal: true

class ItemLink < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true
  belongs_to :namespace

  validates :source, presence: true
  validates :target, presence: true
  validates :namespace, presence: true
  validate :no_self_link

  scope :for_source, ->(item) { where(source: item) }

  private

  def no_self_link
    return unless source_id == target_id && source_type == target_type

    errors.add(:source, 'cannot be linked to itself')
  end
end
