# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module DiffFile
  extend ActiveSupport::Concern

  def to_hash
    keys = Gitlab::Git::Diff::SERIALIZE_KEYS - [:diff]

    as_json(only: keys).merge(diff: diff).with_indifferent_access
  end
end
