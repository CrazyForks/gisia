class Board < ApplicationRecord
  belongs_to :project
  belongs_to :namespace
  belongs_to :updated_by, class_name: 'User'
  has_many :board_stages, dependent: :destroy
end
