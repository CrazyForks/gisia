# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module BlobLanguageFromGitAttributes
  extend ActiveSupport::Concern

  def language_from_gitattributes
    return unless repository&.exists?

    repository.gitattribute(path, 'gitlab-language')
  end
end
