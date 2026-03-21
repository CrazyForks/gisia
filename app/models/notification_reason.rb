# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

class NotificationReason
  OWN_ACTIVITY = 'own_activity'
  ASSIGNED = 'assigned'
  REVIEW_REQUESTED = 'review_requested'
  MENTIONED = 'mentioned'
  SUBSCRIBED = 'subscribed'

  REASON_PRIORITY = [
    OWN_ACTIVITY,
    ASSIGNED,
    REVIEW_REQUESTED,
    MENTIONED,
    SUBSCRIBED
  ].freeze

  def self.priority(reason)
    REASON_PRIORITY.index(reason) || (REASON_PRIORITY.length + 1)
  end
end
