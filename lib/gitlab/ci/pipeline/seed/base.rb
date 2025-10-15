# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Pipeline
      module Seed
        class Base
          def attributes
            raise NotImplementedError
          end

          def included?
            raise NotImplementedError
          end

          def errors
            raise NotImplementedError
          end

          def to_resource
            raise NotImplementedError
          end
        end
      end
    end
  end
end
