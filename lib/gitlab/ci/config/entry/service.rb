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
        # Entry that represents a configuration of Docker service.
        #
        class Service < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Ci::Config::Entry::Imageable

          ALLOWED_KEYS = %i[command alias variables].freeze

          validations do
            validates :config, allowed_keys: ALLOWED_KEYS + IMAGEABLE_ALLOWED_KEYS
            validates :command, array_of_strings: true, allow_nil: true
            validates :alias, type: String, allow_nil: true
            validates :alias, type: String, presence: true, unless: ->(record) { record.ports.blank? }
          end

          entry :variables, ::Gitlab::Ci::Config::Entry::Variables,
            description: 'Environment variables available for this service.',
            inherit: false

          attributes :variables

          def alias
            value[:alias]
          end

          def command
            value[:command]
          end

          def value
            if hash?
              super.merge(
                command: @config[:command],
                alias: @config[:alias],
                variables: (variables_value if variables_defined?)
              ).compact
            else
              super
            end
          end
        end
      end
    end
  end
end
