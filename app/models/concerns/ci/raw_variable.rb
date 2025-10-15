# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  module RawVariable
    extend ActiveSupport::Concern

    included do
      validates :raw, inclusion: { in: [true, false] }
    end

    private

    def uncached_hash_variable
      super.merge(raw: raw?)
    end
  end
end
