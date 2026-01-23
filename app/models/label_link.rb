# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class LabelLink < ApplicationRecord
  belongs_to :label
  belongs_to :labelable, polymorphic: true

  before_save :validate_scoped_label_uniqueness

  private

  def validate_scoped_label_uniqueness
    return unless labelable_type == 'WorkItem'
    return unless label&.title&.include?('::')

    scope = label.title.split('::').first
    existing = LabelLink.joins(:label)
                        .where(labelable_id: labelable_id, labelable_type: 'WorkItem')
                        .where('labels.title LIKE ?', "#{scope}::%")
                        .where.not(id: id)
                        .exists?

    raise ActiveRecord::RecordNotSaved, "Label scope '#{scope}' already exists" if existing
  end
end
