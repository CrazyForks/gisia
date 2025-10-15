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
        # This class represents a inherit entry
        #
        class Inherit < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Configurable

          ALLOWED_KEYS = %i[default variables].freeze

          validations do
            validates :config, allowed_keys: ALLOWED_KEYS
          end

          entry :default, ::Gitlab::Ci::Config::Entry::Inherit::Default,
            description: 'Indicates whether to inherit `default:`.',
            default: true

          entry :variables, ::Gitlab::Ci::Config::Entry::Inherit::Variables,
            description: 'Indicates whether to inherit `variables:`.',
            default: true
        end
      end
    end
  end
end
