# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module CachedCommit
  extend ActiveSupport::Concern

  def to_hash(exclude_keys: [])
    (Gitlab::Git::Commit::SERIALIZE_KEYS - exclude_keys).index_with do |key|
      public_send(key) # rubocop:disable GitlabSecurity/PublicSend
    end
  end

  # We don't save these, because they would need a table or a serialized
  # field. They aren't used anywhere, so just pretend the commit has no parents.
  def parent_ids
    []
  end

  # These are not saved
  def referenced_by
    []
  end

  def extended_trailers
    {}
  end
end
