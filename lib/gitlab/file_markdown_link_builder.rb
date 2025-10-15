# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# Builds the markdown link of a file
# It needs the methods filename and secure_url (final destination url) to be defined.
module Gitlab
  module FileMarkdownLinkBuilder
    include FileTypeDetection

    def markdown_link
      return unless name = markdown_name

      markdown = "[#{name.gsub(']', '\\]')}](#{secure_url})"
      markdown = "!#{markdown}" if embeddable? || dangerous_embeddable?
      markdown
    end

    def markdown_name
      return unless filename.present?

      embeddable? ? File.basename(filename, File.extname(filename)) : filename
    end
  end
end
