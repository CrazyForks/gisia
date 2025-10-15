# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitalyClient
    class ListBlobsAdapter
      include Enumerable

      def initialize(rpc_response)
        @rpc_response = rpc_response
      end

      def each
        @rpc_response.each do |msg|
          msg.blobs.each do |blob|
            yield blob
          end
        end
      end
    end
  end
end
