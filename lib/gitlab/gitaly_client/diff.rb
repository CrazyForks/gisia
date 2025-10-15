# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitalyClient
    class Diff
      # Attributes exposed from Gitaly's CommitDiffResponse
      ATTRS = %i[
        from_path to_path old_mode new_mode from_id to_id patch overflow_marker collapsed too_large binary
      ].freeze

      include AttributesBag
    end
  end
end
