# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Utils
    module Markdown
      PUNCTUATION_REGEXP = /[^\p{Word}\- ]/u

      def string_to_anchor(string)
        string
          .strip
          .downcase
          .gsub(PUNCTUATION_REGEXP, '') # remove punctuation
          .tr(' ', '-') # replace spaces with dash
          .squeeze('-') # replace multiple dashes with one
          .gsub(/\A(\d+)\z/, 'anchor-\1') # digits-only hrefs conflict with issue refs
      end
    end
  end
end
