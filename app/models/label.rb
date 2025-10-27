class Label < ApplicationRecord
  belongs_to :namespace
  has_many :label_work_items, dependent: :destroy
  has_many :work_items, through: :label_work_items

  validates :title, presence: true
  validates :color, presence: true
  validates :namespace_id, presence: true
end
