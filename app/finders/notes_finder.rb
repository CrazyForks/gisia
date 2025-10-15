# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class NotesFinder
  NOTES_FILTERS = {
    all_notes: 0,
    comments: 1
  }.freeze

  attr_reader :current_user, :params

  def initialize(current_user, params = {})
    @current_user = current_user
    @params = params
  end

  def execute
    notes = init_collection
    notes = by_noteable(notes)
    notes = by_namespace(notes)
    notes = by_notes_filter(notes)
    notes = by_search(notes)
    notes = apply_sorting(notes)

    notes
  end

  private

  # Todo,
  # Add access check
  def init_collection
    if params[:noteable]
      # Use specific partition model for better performance
      noteable_type = params[:noteable].class.name
      Note.partition_model_for(noteable_type).all
    else
      # Query all partitions if no specific noteable
      Note.all
    end
  end

  def by_noteable(notes)
    return notes unless params[:noteable]

    notes.where(noteable: params[:noteable])
  end

  def by_namespace(notes)
    return notes unless params[:namespace]

    notes.where(namespace: params[:namespace])
  end

  def by_notes_filter(notes)
    filter = params[:notes_filter] || NOTES_FILTERS[:all_notes]

    case filter
    when NOTES_FILTERS[:comments]
      notes.user
    else
      notes
    end
  end

  def by_search(notes)
    return notes unless params[:search].present?

    notes.search(params[:search])
  end

  def apply_sorting(notes)
    case params[:sort]
    when 'created_desc'
      notes.order_created_desc
    when 'updated_desc'
      notes.order_updated_desc
    else
      notes.order_created_asc
    end
  end
end
