# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Config
    module Entry
      class Validator < SimpleDelegator
        include ActiveModel::Validations
        include Entry::Validators

        def messages
          errors.full_messages.map do |error|
            "#{location} #{error}".downcase
          end
        end

        def self.name
          'Validator'
        end
      end
    end
  end
end
