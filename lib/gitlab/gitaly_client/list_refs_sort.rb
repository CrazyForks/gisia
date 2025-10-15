# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitalyClient
    class ListRefsSort
      def initialize(sort_by)
        @sort_by = sort_by
      end

      def gitaly_sort_by
        Gitaly::ListRefsRequest::SortBy.new(
          key: key,
          direction: direction
        )
      end

      private

      attr_reader :sort_by

      def key
        return Gitaly::ListRefsRequest::SortBy::Key::CREATORDATE if match?('updated')

        Gitaly::ListRefsRequest::SortBy::Key::REFNAME
      end

      def direction
        return Gitaly::SortDirection::DESCENDING if match?('desc')

        Gitaly::SortDirection::ASCENDING
      end

      def match?(key)
        return false if sort_by.blank?

        sort_by.downcase.split('_').include?(key)
      end
    end
  end
end
