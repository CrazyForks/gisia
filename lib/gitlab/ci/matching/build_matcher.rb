# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Matching
      class BuildMatcher
        ATTRIBUTES = %i[
          protected
          tag_list
          build_ids
          project
        ].freeze

        attr_reader(*ATTRIBUTES)
        alias_method :protected?, :protected

        def initialize(params)
          ATTRIBUTES.each do |attribute|
            instance_variable_set("@#{attribute}", params.fetch(attribute))
          end
        end

        def has_tags?
          tag_list.present?
        end
      end
    end
  end
end
