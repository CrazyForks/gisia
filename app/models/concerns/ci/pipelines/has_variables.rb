# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module Pipelines
    module HasVariables
      extend ActiveSupport::Concern
      include Gitlab::Routing.url_helpers
      include ProjectsHelper

      included do
        has_many :variables, class_name: 'Ci::PipelineVariable', inverse_of: :pipeline, dependent: :destroy
        accepts_nested_attributes_for :variables, reject_if: :persisted?
      end

      def persisted_variables
        Gitlab::Ci::Variables::Collection.new.tap do |variables|
          break variables unless persisted?

          variables.append(key: 'CI_PIPELINE_ID', value: id.to_s)
          variables.append(key: 'CI_PIPELINE_URL',
            value: pipeline_url(self))
        end
      end
    end
  end
end
