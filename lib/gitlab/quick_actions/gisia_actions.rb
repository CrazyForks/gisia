# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

# Adapted from GitLab FOSS lib/gitlab/quick_actions/issuable_actions.rb

module Gitlab
  module QuickActions
    # Gisia-only quick actions. Kept out of the verbatim IssuableActions port so
    # that file stays byte-identical to upstream and can be re-synced with a
    # plain copy.
    #
    # Upstream registers the reopen action as `/reopen` only. Gisia also accepts
    # `/open`, registered here as a separate definition with the same body.
    module GisiaActions
      extend ActiveSupport::Concern
      include Gitlab::QuickActions::Dsl

      included do
        desc do
          _('Reopen this %{quick_action_target}') % { quick_action_target: target_issuable_name }
        end
        explanation do
          _('Reopens this %{quick_action_target}.') % { quick_action_target: target_issuable_name }
        end
        execution_message do
          _('Reopened this %{quick_action_target}.') % { quick_action_target: target_issuable_name }
        end
        types ::Issuable
        condition do
          quick_action_target.persisted? &&
            quick_action_target.closed? &&
            current_user.can?(:"update_#{quick_action_target.to_ability_name}", quick_action_target)
        end
        command :open do
          @updates[:state_event] = 'reopen'
        end
      end
    end
  end
end
