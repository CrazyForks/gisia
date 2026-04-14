# frozen_string_literal: true

module Activities
  module Trackable
    extend ActiveSupport::Concern

    included do
      after_save :create_label_activities
      after_update_commit :create_change_activities
    end

    private

    def create_label_activities
      return unless @prev_activity_label_ids

      current_ids = LabelLink.where(labelable: self).pluck(:label_id).sort
      added_ids   = current_ids - @prev_activity_label_ids
      removed_ids = @prev_activity_label_ids - current_ids

      build_activity(:label_added, details: { 'label_ids' => added_ids }) if added_ids.any?
      build_activity(:label_removed, details: { 'label_ids' => removed_ids }) if removed_ids.any?

      @prev_activity_label_ids = nil
    end

    def create_change_activities
      if saved_changes.key?('state_id') || (saved_changes.key?('status') && (closed? || opened?))
        build_activity(closed? ? :closed : :reopened)
      end

      if saved_change_to_title?
        from, to = saved_change_to_title
        build_activity(:title_changed, details: { 'from' => from, 'to' => to })
      end

      if saved_change_to_description?
        from, to = saved_change_to_description
        diff = Diffy::Diff.new(from.to_s, to.to_s).to_s(:text)
        build_activity(:description_changed, details: { 'diff' => diff })
      end

      create_assignee_activities
    end

    def create_assignee_activities
      return unless @previous_assignee_ids

      current_ids = current_assignee_ids_for_activity
      added_ids   = current_ids - @previous_assignee_ids
      removed_ids = @previous_assignee_ids - current_ids

      build_activity(:assignee_added, details: { 'user_ids' => added_ids }) if added_ids.any?
      build_activity(:assignee_removed, details: { 'user_ids' => removed_ids }) if removed_ids.any?
    end

    def current_assignee_ids_for_activity
      []
    end

    def build_activity(action_type, details: nil)
      trackable_type = self.class.name
      Activity.partition_model_for(trackable_type).create!(
        trackable_type: trackable_type,
        trackable_id: id,
        author_id: notification_author&.id,
        action_type: action_type,
        details: details,
        created_at: Time.current
      )
    end
  end
end
