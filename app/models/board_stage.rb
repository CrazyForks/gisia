class BoardStage < ApplicationRecord
  belongs_to :board

  scope :ordered, -> { order(:rank) }
end
