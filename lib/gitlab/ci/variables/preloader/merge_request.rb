# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Variables
      module Preloader
        class MergeRequest
          def initialize(merge_request)
            @merge_request = merge_request
          end

          def preload
            ActiveRecord::Associations::Preloader.new(
              records: [@merge_request],
              associations: preloads
            ).call
          end

          private

          def preloads
            []
          end
        end
      end
    end
  end
end

Gitlab::Ci::Variables::Preloader::MergeRequest.prepend_mod_with('Gitlab::Ci::Variables::Preloader::MergeRequest')
