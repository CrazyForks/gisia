# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  class Unicode
    # Regular expression for identifying bidirectional control
    # characters in UTF-8 strings
    #
    # Documentation on how this works:
    # https://idiosyncratic-ruby.com/41-proper-unicoding.html
    BIDI_REGEXP = /\p{Bidi Control}/

    # Regular expression for identifying space characters
    #
    # In web browsers space characters can be confused with simple
    # spaces which may be misleading
    SPACE_REGEXP = /\p{Space_Separator}/

    class << self
      # Warning message used to highlight bidi characters in the GUI
      def bidi_warning
        _("Potentially unwanted character detected: Unicode BiDi Control")
      end
    end
  end
end
