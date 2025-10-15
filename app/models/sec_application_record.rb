# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

class SecApplicationRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :sec, reading: :sec } if Gitlab::Database.has_config?(:sec)
end
