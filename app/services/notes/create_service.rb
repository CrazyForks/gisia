# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Notes
  class CreateService < BaseService
    def execute
      note = build_note

      return note unless note.valid?

      note.save!
      note
    end

    private

    def build_note
      note = Note.new(note_params)
      note.namespace = project.namespace
      note.author = current_user
      note
    end

    def note_params
      params.except(:noteable).tap do |whitelisted|
        whitelisted[:noteable] = params[:noteable]
        whitelisted[:noteable_type] = params[:noteable].class.name
        whitelisted[:noteable_id] = params[:noteable].id
      end
    end
  end
end
