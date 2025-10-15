# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Template
    class ServiceDeskTemplate < BaseTemplate
      class << self
        def extension
          '.md'
        end

        def base_dir
          '.gitlab/service_desk_templates/'
        end

        def finder(project)
          Gitlab::Template::Finders::RepoTemplateFinder.new(project, self.base_dir, self.extension, self.categories)
        end
      end
    end
  end
end
