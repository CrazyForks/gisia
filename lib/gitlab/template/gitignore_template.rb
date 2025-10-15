# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Template
    class GitignoreTemplate < BaseTemplate
      class << self
        def extension
          '.gitignore'
        end

        def categories
          {
            "Languages" => '',
            "Global" => 'Global'
          }
        end

        def base_dir
          Rails.root.join('vendor/gitignore')
        end

        def finder(project = nil)
          Gitlab::Template::Finders::GlobalTemplateFinder.new(self.base_dir, self.extension, self.categories)
        end
      end
    end
  end
end
