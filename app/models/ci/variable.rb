# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  class Variable < Ci::ApplicationRecord
    include Ci::HasVariable
    include Ci::Maskable
    include Ci::RawVariable
    include Ci::HidableVariable

    prepend HasEnvironmentScope

    belongs_to :namespace

    alias_attribute :secret_value, :value

    validates :description, length: { maximum: 255 }, allow_blank: true
    validates :key, uniqueness: {
      scope: [:namespace_id, :environment_scope],
      message: "(%{value}) has already been taken"
    }

    scope :unprotected, -> { where(protected: false) }
  end
end

