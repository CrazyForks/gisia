class Label < ApplicationRecord
  belongs_to :namespace
  has_many :label_links, dependent: :destroy
  has_many :work_items, through: :label_links, source: :labelable, source_type: 'WorkItem'
  has_many :merge_requests, through: :label_links, source: :labelable, source_type: 'MergeRequest'

  validates :title, presence: true
  validates :color, presence: true
  validates :namespace_id, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    ['title']
  end
end
