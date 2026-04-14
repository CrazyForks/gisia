# frozen_string_literal: true

class IssueActivity < Activity
  belongs_to :trackable, -> { where(type: 'Issue') }, class_name: 'WorkItem', foreign_key: :trackable_id

  before_validation :set_trackable_type

  private

  def set_trackable_type
    self.trackable_type = 'Issue'
  end
end
