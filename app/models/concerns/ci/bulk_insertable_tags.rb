# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  module BulkInsertableTags
    extend ActiveSupport::Concern

    BULK_INSERT_TAG_THREAD_KEY = 'ci_bulk_insert_tags'

    class << self
      def with_bulk_insert_tags
        previous = Thread.current[BULK_INSERT_TAG_THREAD_KEY]
        Thread.current[BULK_INSERT_TAG_THREAD_KEY] = true
        yield
      ensure
        Thread.current[BULK_INSERT_TAG_THREAD_KEY] = previous
      end
    end

    # overrides save_tags from acts-as-taggable
    def save_tags
      super unless Thread.current[BULK_INSERT_TAG_THREAD_KEY]
    end
  end
end
