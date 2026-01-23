# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Markup
  class RenderingService
    def initialize(text, file_name: nil, context: {}, postprocess_context: {})
      @text = text
      @file_name = file_name
      @context = context
      @postprocess_context = postprocess_context
    end

    def execute
      return '' unless text.present?
      return context.delete(:rendered) if context.has_key?(:rendered)

      html = markup_unsafe

      return '' unless html.present?

      postprocess_context ? postprocess(html) : html
    end

    private

    def markup_unsafe
      return markdown_unsafe unless file_name

      if gitlab_markdown?(file_name)
        markdown_unsafe
      elsif plain?(file_name)
        plain_unsafe
      else
        other_markup_unsafe
      end
    end

    def markdown_unsafe
      Banzai.render(text, context)
    end

    def plain_unsafe
      ActionController::Base.helpers.content_tag :pre, class: 'plain-readme' do
        text
      end
    end

    def other_markup_unsafe
      GitHub::Markup.render(file_name, text)
    rescue => e
      ActionController::Base.helpers.simple_format(text)
    end

    def postprocess(html)
      Banzai.post_process(html, context.reverse_merge(postprocess_context))
    end

    def gitlab_markdown?(file_name)
      return true unless file_name
      %w[.md .markdown .mdown .mkd .mkdn].include?(File.extname(file_name.downcase))
    end

    def plain?(file_name)
      return false unless file_name
      %w[.txt .text].include?(File.extname(file_name.downcase))
    end

    attr_reader :text, :file_name, :context, :postprocess_context
  end
end