# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  class ChangesList
    include Enumerable

    attr_reader :raw_changes

    def initialize(changes)
      @raw_changes = changes.is_a?(String) ? changes.lines : changes
    end

    def each(&block)
      changes.each(&block)
    end

    def changes
      @changes ||= @raw_changes.filter_map do |change|
        next if change.blank?

        oldrev, newrev, ref = change.strip.split(' ')
        { oldrev: oldrev, newrev: newrev, ref: ref }
      end
    end
  end
end
