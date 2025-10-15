# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module DependencyLinker
    module Cocoapods
      def package_url(name)
        package = name.split("/", 2).first
        "https://cocoapods.org/pods/#{package}"
      end
    end
  end
end
