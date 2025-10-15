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
        # Entry that represents a configuration of release:assets:links.
        #
        class Release
          class Assets
            class Link < ::Gitlab::Config::Entry::Node
              include ::Gitlab::Config::Entry::Validatable
              include ::Gitlab::Config::Entry::Attributable

              ALLOWED_KEYS = %i[name url].freeze

              attributes ALLOWED_KEYS

              validations do
                validates :config, allowed_keys: ALLOWED_KEYS

                validates :name, type: String, presence: true
                validates :url, presence: true, addressable_url: true
              end
            end
          end
        end
      end
    end
  end
end
