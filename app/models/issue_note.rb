# frozen_string_literal: true

class IssueNote < Note
  belongs_to :noteable, -> { where(type: 'Issue') }, class_name: 'WorkItem', foreign_key: :noteable_id

  scope :with_issue, ->(issue) { where(noteable: issue) }

  def issue
    noteable
  end
end
