# frozen_string_literal: true

class BoardStage < ApplicationRecord
  belongs_to :board

  scope :ordered, -> { order(:rank) }

  def labels
    Label.where(id: label_ids)
  end

  validates :kind, uniqueness: { scope: :board_id, if: -> { kind == 'closed' }, message: 'can only have one closed stage per board' }

  after_create :increment_closed_stage_rank

  enum :kind, WorkItems::HasState::STATE_ID_MAP

  private

  def increment_closed_stage_rank
    closed_stage = board.stages.find_by(kind: :closed)
    closed_stage&.increment!(:rank)
  end
end
