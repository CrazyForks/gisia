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
  class JobVariable < Ci::ApplicationRecord
    include Ci::NewHasVariable
    include Ci::RawVariable

    attr_accessor :partition_id

    before_validation :set_project_id, on: :create

    include BulkInsertSafe

    belongs_to :job, class_name: 'Ci::Build', foreign_key: :job_id, inverse_of: :job_variables

    alias_attribute :secret_value, :value

    validates :key, uniqueness: { scope: :job_id }, unless: :dotenv_source?
    validates :project_id, presence: true, on: :create

    enum :source, { internal: 0, dotenv: 1 }, suffix: true

    def set_project_id
      self.project_id ||= job&.project_id
    end
  end
end
