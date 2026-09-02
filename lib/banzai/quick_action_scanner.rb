# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Banzai
  # Extracts the source position of top-level paragraphs that may contain quick
  # actions, so Gitlab::QuickActions::Extractor can limit its regex to them.
  #
  # Only top-level paragraphs are considered, which is what keeps commands
  # inside fenced code blocks, block quotes and HTML blocks from being executed.
  #
  # Upstream does this as an HTML::Pipeline filter over a rendered document.
  # Gisia has no HTML pipeline, so this walks the CommonMarker AST directly,
  # the same way Banzai::MentionScanner does. The returned shape
  # (`[{ start_line:, end_line: }]`, both 0-indexed) matches upstream.
  class QuickActionScanner
    def self.scan(text)
      new(text).scan
    end

    def initialize(text)
      @text = text
    end

    def scan
      return [] if text.blank?

      lines = text.lines

      doc.each.filter_map do |node|
        next unless node.type == :paragraph

        pos = node.sourcepos
        start_line = pos[:start_line] - 1
        end_line = pos[:end_line] - 1

        next unless lines[start_line..end_line].to_a.any? { |line| line.start_with?('/') }

        { start_line: start_line, end_line: end_line }
      end
    end

    private

    attr_reader :text

    def doc
      @doc ||= CommonMarker.render_doc(text, :SOURCEPOS, MentionScanner::EXTENSIONS)
    end
  end
end
