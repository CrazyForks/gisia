# frozen_string_literal: true

module Projects::NotesHelper
  def note_edit_path(note)
    edit_form_namespace_project_note_path(
      note.noteable.project.namespace.parent.full_path,
      note.noteable.project.path,
      note.id,
      noteable_type: note.noteable_type
    )
  end

  def note_path(note)
    namespace_project_note_path(
      note.noteable.project.namespace.parent.full_path,
      note.noteable.project.path,
      note.id,
      noteable_type: note.noteable_type
    )
  end

  def expand_note_path(note)
    expand_namespace_project_note_path(
      note.noteable.project.namespace.parent.full_path,
      note.noteable.project.path,
      note.id
    )
  end

  def collapse_note_path(note)
    collapse_namespace_project_note_path(
      note.noteable.project.namespace.parent.full_path,
      note.noteable.project.path,
      note.id
    )
  end

  def note_show_path(note)
    show_form_namespace_project_note_path(
      note.noteable.project.namespace.parent.full_path,
      note.noteable.project.path,
      note.id,
      noteable_type: note.noteable_type
    )
  end
end