# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Routing
  module PackagesHelper
    def package_path(package, **options)
      Gitlab::UrlBuilder.build(package, only_path: true, **options)
    end
  end
end
