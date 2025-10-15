# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  class StringRegexMarker < StringRangeMarker
    def mark(regex, group: 0, &block)
      ranges = ranges(regex, group: group)

      super(ranges, &block)
    end

    def mark_with_ranges(ranges, &block)
      method(:mark).super_method.call(ranges, &block)
    end

    def ranges(regex, group: 0)
      ranges = []
      offset = 0

      while match = regex.match(raw_line[offset..])
        begin_index = match.begin(group) + offset
        end_index = match.end(group) + offset

        ranges << (begin_index..(end_index - 1))

        offset = end_index
      end

      ranges
    end
  end
end
