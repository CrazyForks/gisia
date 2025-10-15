# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module DiffViewer
  module Rich
    extend ActiveSupport::Concern

    included do
      self.type = :rich
      self.switcher_icon = 'doc-text'

      def self.switcher_title
        _('rendered diff')
      end
    end
  end
end
