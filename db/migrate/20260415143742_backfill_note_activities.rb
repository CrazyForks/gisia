class BackfillNoteActivities < ActiveRecord::Migration[8.0]
  NOTEABLE_TYPES = %w[Issue MergeRequest Epic].freeze

  def up
    notes_to_backfill.find_each do |note|
      activity_model_for(note.noteable_type).create!(
        trackable_type: note.noteable_type,
        trackable_id: note.noteable_id,
        author_id: note.author_id,
        action_type: 2,
        note_id: note.id,
        created_at: note.created_at
      )
    end
  end

  def down
    Activity.where(action_type: 2)
            .where(note_id: notes_to_backfill.select(:id))
            .delete_all
  end

  private

  def notes_to_backfill
    Note.where(noteable_type: NOTEABLE_TYPES, discussion_id: nil)
        .where.not(id: Activity.where(action_type: 2).where.not(note_id: nil).select(:note_id))
  end

  def activity_model_for(noteable_type)
    case noteable_type
    when 'Issue' then IssueActivity
    when 'MergeRequest' then MergeRequestActivity
    when 'Epic' then EpicActivity
    end
  end
end
