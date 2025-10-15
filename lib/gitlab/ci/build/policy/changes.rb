# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Build
      module Policy
        class Changes < Policy::Specification
          def initialize(globs)
            @globs = Array(globs)
          end

          def satisfied_by?(pipeline, context)
            return true if pipeline.modified_paths.nil?

            pipeline.modified_paths.any? do |path|
              @globs.any? do |glob|
                File.fnmatch?(glob, path, File::FNM_PATHNAME | File::FNM_DOTMATCH | File::FNM_EXTGLOB)
              end
            end
          end
        end
      end
    end
  end
end
