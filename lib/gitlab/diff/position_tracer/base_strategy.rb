# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Diff
    class PositionTracer
      class BaseStrategy
        attr_reader :tracer

        delegate \
          :project,
          :diff_file,
          :ac_diffs,
          :bd_diffs,
          :cd_diffs,
          to: :tracer

        def initialize(tracer)
          @tracer = tracer
        end

        def trace(position)
          raise NotImplementedError
        end
      end
    end
  end
end
