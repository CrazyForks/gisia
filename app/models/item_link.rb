# frozen_string_literal: true

class ItemLink < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true
  belongs_to :namespace

  attr_accessor :activity_author

  validates :source, presence: true
  validates :target, presence: true
  validates :namespace, presence: true
  validate :no_self_link

  after_create_commit :create_linked_activity
  after_destroy_commit :create_unlinked_activity

  scope :for_source, ->(item) { where(source: item) }

  private

  def no_self_link
    return unless source_id == target_id && source_type == target_type

    errors.add(:source, 'cannot be linked to itself')
  end

  def create_linked_activity
    create_item_activity(:item_linked)
  end

  def create_unlinked_activity
    create_item_activity(:item_unlinked)
  end

  def create_item_activity(action_type)
    trackable_type = source.class.name
    Activity.partition_model_for(trackable_type).create!(
      trackable_type: trackable_type,
      trackable_id: source.id,
      author_id: activity_author&.id,
      action_type: action_type,
      details: { 'target_type' => target.class.name, 'target_id' => target.id },
      created_at: Time.current
    )
  end
end
