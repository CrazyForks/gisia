# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module BlobViewer
  module Auxiliary
    extend ActiveSupport::Concern

    include Gitlab::Allowable

    included do
      self.loading_partial_name = 'loading_auxiliary'
      self.type = :auxiliary
      self.collapse_limit = 100.kilobytes
      self.size_limit = 100.kilobytes
    end

    def visible_to?(_current_user, _ref)
      true
    end
  end
end

