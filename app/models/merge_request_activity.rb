# frozen_string_literal: true

class MergeRequestActivity < Activity
  belongs_to :trackable, class_name: 'MergeRequest', foreign_key: :trackable_id

  before_validation :set_trackable_type

  private

  def set_trackable_type
    self.trackable_type = 'MergeRequest'
  end
end
