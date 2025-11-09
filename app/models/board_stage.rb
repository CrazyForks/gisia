# frozen_string_literal: true

class BoardStage < ApplicationRecord
  belongs_to :board

  scope :ordered, -> { order(:rank) }

  validates :kind, uniqueness: { scope: :board_id, if: -> { kind == 'closed' }, message: 'can only have one closed stage per board' }

  enum :kind, WorkItems::HasState::STATE_ID_MAP
end
