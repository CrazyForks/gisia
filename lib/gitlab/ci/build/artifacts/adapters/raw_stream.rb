# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      module Artifacts
        module Adapters
          class RawStream
            attr_reader :stream

            InvalidStreamError = Class.new(StandardError)

            def initialize(stream)
              raise InvalidStreamError, "Stream is required" unless stream

              @stream = stream
            end

            def each_blob
              stream.seek(0)

              yield(stream.read, 'raw') unless stream.eof?
            end
          end
        end
      end
    end
  end
end
