# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Pipeline
      module Chain
        class CreateCrossDatabaseAssociations < Chain::Base
          def perform!
            # to be overridden in EE
          end

          def break?
            false # to be overridden in EE
          end
        end
      end
    end
  end
end

Gitlab::Ci::Pipeline::Chain::CreateCrossDatabaseAssociations.prepend_mod_with('Gitlab::Ci::Pipeline::Chain::CreateCrossDatabaseAssociations')
