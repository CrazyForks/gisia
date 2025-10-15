# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# It is a Range object extended with `mode` attribute
# MarkerRange not only keeps information about changed characters, but also
# the type of changes
module Gitlab
  class MarkerRange < Range
    DELETION = :deletion
    ADDITION = :addition

    # Converts Range object to MarkerRange class
    def self.from_range(range)
      return range if range.is_a?(self)

      new(range.begin, range.end, exclude_end: range.exclude_end?)
    end

    def initialize(first, last, exclude_end: false, mode: nil)
      super(first, last, exclude_end)
      @mode = mode
    end

    def to_range
      Range.new(self.begin, self.end, self.exclude_end?)
    end

    def ==(other)
      return false unless other.is_a?(self.class)

      self.mode == other.mode && super
    end

    attr_reader :mode
  end
end
