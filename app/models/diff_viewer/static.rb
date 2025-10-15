# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module DiffViewer
  module Static
    extend ActiveSupport::Concern

    # We can always render a static viewer, even if the diff is too large.
    def render_error
      nil
    end
  end
end
