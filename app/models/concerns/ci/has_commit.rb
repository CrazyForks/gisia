# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module HasCommit
    extend ActiveSupport::Concern
    include ::Gitlab::Utils::StrongMemoize

    included do
      validate :valid_commit_sha
    end

    def commit
      @commit ||= Commit.lazy(project, sha)
    end

    def valid_commit_sha
      errors.add(:sha, "can't be 00000000 (branch removal)") if Gitlab::Git.blank_ref?(sha)
    end

    def git_author_name
      strong_memoize(:git_author_name) do
        commit.try(:author_name)
      end
    end

    def git_author_email
      strong_memoize(:git_author_email) do
        commit.try(:author_email)
      end
    end

    def git_author_full_text
      strong_memoize(:git_author_full_text) do
        commit.try(:author_full_text)
      end
    end

    def git_commit_message
      strong_memoize(:git_commit_message) do
        commit.try(:message)
      end
    end

    def git_commit_title
      strong_memoize(:git_commit_title) do
        commit.try(:title)
      end
    end

    def git_commit_full_title
      strong_memoize(:git_commit_full_title) do
        commit.try(:full_title)
      end
    end

    def git_commit_message
      strong_memoize(:git_commit_message) do
        commit.try(:message)
      end
    end

    def git_commit_description
      strong_memoize(:git_commit_description) do
        commit.try(:description)
      end
    end

    def git_commit_timestamp
      # Todo, no value
      strong_memoize(:git_commit_timestamp) do
        commit.try(:timestamp)
      end
    end

    def before_sha
      super || project.repository.blank_ref
    end

    def short_sha
      Ci::Pipeline.truncate_sha(sha)
    end
  end
end
