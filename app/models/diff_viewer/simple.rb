# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module DiffViewer
  module Simple
    extend ActiveSupport::Concern

    included do
      self.type = :simple
      self.switcher_icon = 'code'

      def self.switcher_title
        _('source diff')
      end
    end
  end
end
