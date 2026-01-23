# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Users
  module HasState
    extend ActiveSupport::Concern

    included do
      enum :state, {
        active: 0,
        blocked: 1,
        banned: 2
      }

      scope :with_states, ->(*names) do
        where(state: names)
      end

      scope :with_state, ->(name) do
        where(state: name)
      end

      state_machine :state, initial: :active, initialize: true do
        state :blocked, :banned do
          def blocked?
            true
          end
        end

        event :block do
          transition active: :blocked
        end

        event :activate do
          transition blocked: :active
          transition banned: :active
        end

        event :ban do
          transition active: :banned
        end

        event :unban do
          transition banned: :active
        end
      end
    end

    def deactivated?
      false
    end

    def blocked_pending_approval?
      false
    end
  end
end
