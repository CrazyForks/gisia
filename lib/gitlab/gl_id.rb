# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GlId
    def self.gl_id(user)
      if user.present?
        gl_id_from_id_value(user.id)
      else
        ''
      end
    end

    def self.gl_id_from_id_value(id)
      "user-#{id}"
    end
  end
end
