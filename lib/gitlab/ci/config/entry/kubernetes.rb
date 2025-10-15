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
        class Kubernetes < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Validatable
          include ::Gitlab::Config::Entry::Attributable

          ALLOWED_KEYS = %i[namespace agent flux_resource_path].freeze

          attributes ALLOWED_KEYS

          validations do
            validates :config, type: Hash, presence: true
            validates :config, allowed_keys: ALLOWED_KEYS

            validates :namespace, type: String, allow_nil: true
            validates :namespace, presence: true, if: -> { flux_resource_path.present? }

            validates :agent, type: String, allow_nil: true
            validates :agent, presence: true, if: -> { flux_resource_path.present? }

            validates :flux_resource_path, type: String, allow_nil: true
          end
        end
      end
    end
  end
end
