# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Variables
      module Downstream
        class Base
          def initialize(context)
            @context = context
          end

          private

          attr_reader :context
        end
      end
    end
  end
end
