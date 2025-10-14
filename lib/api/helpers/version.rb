# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module API
  module Helpers
    class Version
      include Helpers::RelatedResourcesHelpers

      def initialize(version)
        @version = version.to_s

        unless ['v4'].include?(version)
          raise ArgumentError, 'Unknown API version!'
        end
      end

      def root_path
        File.join('/', 'api/', @version)
      end

      def root_url
        @root_url ||= expose_url(root_path)
      end

      def to_s
        @version
      end
    end
  end
end
