# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module Header
        class Spec < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Configurable

          ALLOWED_KEYS = %i[inputs].freeze

          validations do
            validates :config, allowed_keys: ALLOWED_KEYS
          end

          entry :inputs, ::Gitlab::Config::Entry::ComposableHash,
            description: 'Allowed input parameters used for interpolation.',
            inherit: false,
            metadata: { composable_class: ::Gitlab::Ci::Config::Header::Input }
        end
      end
    end
  end
end
