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
  class UrlBuilder
    include Singleton
    include Gitlab::Routing
    include GitlabRoutingHelper

    delegate :build, to: :class

    def project_url(project, **)
      ::Gitlab::Routing.url_helpers.namespace_project_url(project.namespace.parent&.full_path, project.namespace.path, **)
    end

    def commit_url(commit, **)
      project = commit.project
      ::Gitlab::Routing.url_helpers.namespace_project_commit_url(
        project.namespace.parent&.full_path,
        project.namespace.path,
        commit.id,
        **
      )
    end

    class << self
      include ActionView::RecordIdentifier

      # Using a case statement here is preferable for readability and maintainability.
      # See discussion in https://gitlab.com/gitlab-org/gitlab/-/issues/217397
      #
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      def build(object, **)
        # Objects are sometimes wrapped in a BatchLoader instance
        case object.itself
        when ::Ci::Build
          instance.project_job_url(object.project, object, **)
        when ::Ci::Pipeline
          instance.project_pipeline_url(object.project, object, **)
        when MergeRequest
          instance.merge_request_url(object, **)
        when Project
          instance.project_url(object, **)
        when User
          instance.user_url(object, **)
        when Namespaces::UserNamespace
          instance.user_url(object.owner, **)
        when Namespaces::ProjectNamespace
          instance.project_url(object.project, **)
        when ::Key
          instance.user_settings_ssh_key_url(object)
        else
          raise NotImplementedError, "No URL builder defined for #{object.inspect}"
        end
      end

      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      def board_url(board, **)
        if board.project_board?
          instance.project_board_url(board.resource_parent, board, **)
        else
          instance.group_board_url(board.resource_parent, board, **)
        end
      end

      def commit_url(commit, **)
        return '' unless commit.project

        instance.commit_url(commit, **)
      end

      def compare_url(compare, **)
        return '' unless compare.project

        instance.project_compare_url(compare.project, **, **compare.to_param)
      end

      def note_url(note, **)
        if note.for_commit?
          return '' unless note.project

          instance.project_commit_url(note.project, note.commit_id, anchor: dom_id(note), **)
        elsif note.for_issue?
          instance.issue_url(note.noteable, anchor: dom_id(note), **)
        elsif note.for_merge_request?
          instance.merge_request_url(note.noteable, anchor: dom_id(note), **)
        elsif note.for_snippet?
          instance.gitlab_snippet_url(note.noteable, anchor: dom_id(note), **)
        elsif note.for_abuse_report?
          instance.admin_abuse_report_url(note.noteable, anchor: dom_id(note), **)
        elsif note.for_wiki_page?
          instance.project_wiki_page_url(note.noteable, anchor: dom_id(note), **)
        end
      end

      def abuse_report_note_url(note, **)
        instance.admin_abuse_report_url(note.abuse_report, anchor: dom_id(note), **)
      end

      def snippet_url(snippet, **options)
        if options[:file].present?
          file, ref = options.values_at(:file, :ref)

          instance.gitlab_raw_snippet_blob_url(snippet, file, ref)
        elsif options.delete(:raw).present?
          instance.gitlab_raw_snippet_url(snippet, **options)
        else
          instance.gitlab_snippet_url(snippet, **options)
        end
      end

      def wiki_url(wiki, **options)
        return wiki_page_url(wiki, Wiki::HOMEPAGE, **options) unless options[:action]

        if wiki.container.is_a?(Project)
          options[:controller] = 'projects/wikis'
          options[:namespace_id] = wiki.container.namespace
          options[:project_id] = wiki.container
        end

        instance.url_for(**options)
      end

      def wiki_page_url(wiki, page, **options)
        options[:action] ||= :show
        options[:id] = page

        wiki_url(wiki, **options)
      end

      def design_url(design, **options)
        size, ref = options.values_at(:size, :ref)
        options.except!(:size, :ref)

        if size
          instance.project_design_management_designs_resized_image_url(design.project, design, ref, size, **options)
        else
          instance.project_design_management_designs_raw_image_url(design.project, design, ref, **options)
        end
      end

      def package_url(package, **)
        project = package.project

        if package.terraform_module?
          return instance.project_infrastructure_registry_url(project, package,
                                                              **)
        end

        instance.project_package_url(project, package, **)
      end
    end
  end
end

Gitlab::UrlBuilder.prepend_mod_with('Gitlab::UrlBuilder')
