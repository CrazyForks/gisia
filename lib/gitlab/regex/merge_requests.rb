# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Regex
    module MergeRequests
      def merge_request
        @merge_request ||= /(?<merge_request>\d+)(?<format>\+s{,1})?/
      end

      def merge_request_draft
        /\A(?i)(\[draft\]|\(draft\)|draft:)/
      end

      def git_diff_prefix
        /\A@@( -\d+,\d+ \+\d+(,\d+)? )@@/
      end
    end
  end
end
