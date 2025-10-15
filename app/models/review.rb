# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

class Review < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id, inverse_of: :reviews
  belongs_to :merge_request, inverse_of: :reviews
  belongs_to :project, inverse_of: :reviews

  has_many :notes, -> { order(:id) }, inverse_of: :review

  delegate :name, to: :author, prefix: true

  def discussion_ids
    notes.select(:discussion_id)
  end

  def from_merge_request_author?
    merge_request.author_id == author_id
  end
end