# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Projects
  module HasBoard
    extend ActiveSupport::Concern

    included do
      after_create :create_default_board
    end

    private

    def create_default_board
      working_on_label = namespace.labels.find_or_create_by(title: 'workflow::working_on') do |label|
        label.color = '#FFA500'
      end

      board = Board.create!(
        namespace: namespace,
        updated_by_id: namespace.creator_id
      )

      BoardStage.create!(
        board: board,
        title: 'Open',
        label_ids: [],
        rank: 0
      )

      BoardStage.create!(
        board: board,
        title: 'Working On',
        label_ids: [working_on_label.id],
        rank: 1
      )

      BoardStage.create!(
        board: board,
        title: 'Closed',
        label_ids: [],
        rank: 2
      )
    end
  end
end
