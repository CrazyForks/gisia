# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Issuable
  extend ActiveSupport::Concern

  included do
    scope :with_state, ->(*states) { where(state_id: states.flatten.map { |s|  WorkItems::HasState::STATE_ID_MAP[s] }) }
  end

  class_methods do
    def available_states
      @available_states ||= WorkItems::HasState::STATE_ID_MAP
    end
  end

  def assignee_username_list
    assignees.map(&:username).to_sentence
  end
end
