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
      after_create :initial_default_board
    end

    private

    def initial_default_board
      initial_workflow_labels
      board = initial_board
      initial_stages(board) if board
    end

    def initial_workflow_labels
      namespace.labels.find_or_create_by(title: 'workflow::todo') do |label|
        label.color = '#66b5d5'
      end

      namespace.labels.find_or_create_by(title: 'workflow::working_on') do |label|
        label.color = '#FFA500'
      end
    end

    def initial_board
      return namespace.board if namespace.board.present?

      Board.create!(
        namespace: namespace,
        updated_by_id: namespace.creator_id
      )
    end

    def initial_stages(board)
      todo_label = namespace.labels.find_by(title: 'workflow::todo')
      working_on_label = namespace.labels.find_by(title: 'workflow::working_on')

      board.stages.find_or_create_by(title: 'Todo') do |stage|
        stage.label_ids = [todo_label.id]
        stage.rank = 0
      end

      board.stages.find_or_create_by(title: 'Working On') do |stage|
        stage.label_ids = [working_on_label.id]
        stage.rank = 1
      end

      board.stages.find_or_create_by(title: 'Closed') do |stage|
        stage.kind = :closed
        stage.label_ids = []
        stage.rank = 20
      end
    end
  end
end

