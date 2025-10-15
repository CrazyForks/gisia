# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# To be included in blob classes which are to be
# treated as ActiveModel.
#
# The blob class must respond_to `project`
module BlobActiveModel
  extend ActiveSupport::Concern

  class_methods do
    def declarative_policy_class
      'BlobPolicy'
    end
  end

  def to_ability_name
    'blob'
  end
end
