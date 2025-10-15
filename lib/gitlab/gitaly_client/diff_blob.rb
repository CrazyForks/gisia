# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitalyClient
    class DiffBlob
      ATTRS = %i[left_blob_id right_blob_id patch status binary over_patch_bytes_limit].freeze

      include AttributesBag # rubocop:disable Layout/ClassStructure -- ATTRS needs to be defined before the include.
    end
  end
end
