# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class NotificationSetting < ApplicationRecord
  include EachBatch
  include FromUnion

  enum :level, { disabled: 0, participating: 1, watch: 2, global: 3, mention: 4, custom: 5 }, default: :global

  belongs_to :user
  belongs_to :source, polymorphic: true, optional: true

  validates :user, presence: true
  validates :level, presence: true
  validates :user_id, uniqueness: {
    scope: [:source_type, :source_id],
    message: 'already exists in source',
    allow_nil: true
  }

  scope :by_sources, ->(sources) { where(source: sources) }
  scope :order_by_id_asc, -> { order(id: :asc) }

  EMAIL_EVENTS = [
    :new_note,
    :new_issue,
    :reopen_issue,
    :close_issue,
    :reassign_issue,
    :new_merge_request,
    :close_merge_request,
    :reassign_merge_request,
    :change_reviewer_merge_request,
    :merge_merge_request,
    :reopen_merge_request,
    :failed_pipeline,
    :fixed_pipeline
  ].freeze

  EXCLUDED_WATCHER_EVENTS = [].freeze

  def self.email_events(_source = nil)
    EMAIL_EVENTS
  end

  def self.find_or_create_for(source)
    setting = find_or_initialize_by(source: source)
    setting.save unless setting.persisted?
    setting
  end

  def failed_pipeline
    bool = super
    bool.nil? || bool
  end
  alias_method :failed_pipeline?, :failed_pipeline

  def fixed_pipeline
    bool = super
    bool.nil? || bool
  end
  alias_method :fixed_pipeline?, :fixed_pipeline

  def event_enabled?(event)
    return failed_pipeline if event.to_sym == :failed_pipeline
    return fixed_pipeline if event.to_sym == :fixed_pipeline

    has_attribute?(event) && !!read_attribute(event)
  end
end
