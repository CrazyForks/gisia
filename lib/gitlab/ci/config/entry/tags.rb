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
        # Entry that represents an array of tags.
        #
        class Tags < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Validatable

          TAGS_LIMIT = 50

          validations do
            validates :config, array_of_strings: true

            validate do
              if config.is_a?(Array) && config.size >= TAGS_LIMIT
                errors.add(:config, _("must be less than the limit of %{tag_limit} tags") % { tag_limit: TAGS_LIMIT })
              end
            end
          end
        end
      end
    end
  end
end
