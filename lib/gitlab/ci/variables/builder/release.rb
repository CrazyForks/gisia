# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    module Variables
      class Builder
        class Release
          include Gitlab::Utils::StrongMemoize

          attr_reader :release

          DESCRIPTION_LIMIT = 1024

          def initialize(release)
            @release = release
          end

          def variables
            strong_memoize(:variables) do
              ::Gitlab::Ci::Variables::Collection.new.tap do |variables|
                next variables unless release

                if release.description
                  variables.append(
                    key: 'CI_RELEASE_DESCRIPTION',
                    value: release.description.truncate(DESCRIPTION_LIMIT),
                    raw: true)
                end

                variables.append(key: 'CI_RELEASE_NAME', value: release.name)
              end
            end
          end
        end
      end
    end
  end
end
