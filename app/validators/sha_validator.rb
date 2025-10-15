# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

class ShaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? || Commit.valid_hash?(value)

    record.errors.add(attribute, 'is not a valid SHA')
  end
end
