# frozen_string_literal: true

class EpicNote < Note
  belongs_to :noteable, -> { where(type: 'Epic') }, class_name: 'WorkItem', foreign_key: :noteable_id

  before_validation :set_noteable_type

  scope :with_epic, ->(epic) { where(noteable: epic) }

  def epic
    noteable
  end

  private

  def set_noteable_type
    self.noteable_type = 'Epic'
  end
end
