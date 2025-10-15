# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitalyClient
    class WikiPage
      ATTRS = %i[title format url_path path name historical raw_data].freeze

      include AttributesBag
      include Gitlab::EncodingHelper

      def initialize(params)
        super

        # All gRPC strings in a response are frozen, so we get an unfrozen
        # version here so appending to `raw_data` doesn't blow up.
        @raw_data = @raw_data.dup

        @title = encode_utf8(@title)
        @path = encode_utf8(@path)
        @name = encode_utf8(@name)
      end

      def historical?
        @historical
      end

      def format
        @format.to_sym
      end
    end
  end
end
