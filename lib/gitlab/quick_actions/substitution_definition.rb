# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Gitlab
  module QuickActions
    class SubstitutionDefinition < CommandDefinition
      # noop?=>true means these won't get extracted or removed by Gitlab::QuickActions::Extractor#extract_commands
      # QuickActions::InterpretService#perform_substitutions handles them separately
      def noop?
        true
      end

      def perform_substitution(context, content)
        return unless content

        all_names.each do |a_name|
          content = content.sub(%r{/#{a_name}(?!\S) ?(.*)$}i, execute_block(action_block, context, '\1'))
        end

        content
      end
    end
  end
end
