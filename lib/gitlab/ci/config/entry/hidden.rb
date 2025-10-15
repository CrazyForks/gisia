# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module Entry
        ##
        # Entry that represents a hidden CI/CD key.
        #
        class Hidden < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Validatable

          validations do
            validates :config, presence: true
          end

          def self.matching?(name, config)
            name.to_s.start_with?('.')
          end

          def self.visible?
            false
          end

          def relevant?
            false
          end
        end
      end
    end
  end
end
