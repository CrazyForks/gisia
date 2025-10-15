# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      module Prerequisite
        class Base
          include Utils::StrongMemoize

          attr_reader :build

          def initialize(build)
            @build = build
          end

          def unmet?
            raise NotImplementedError
          end

          def complete!
            raise NotImplementedError
          end
        end
      end
    end
  end
end
