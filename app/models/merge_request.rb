# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class MergeRequest < ApplicationRecord
  include AtomicInternalId
  include MergeRequests::Status
  include MergeRequests::MergeStatus
  include Issuable
  include Noteable

  include Diffable
  include RefComparable
  include ManualInverseAssociation
  include MergeRequests::ReloadDiffs
  include MergeRequests::Pipelines
  include MergeRequests::Variables

  belongs_to :target_project, class_name: 'Project'
  belongs_to :source_project, class_name: 'Project'
  belongs_to :merge_user, class_name: 'User', optional: true
  belongs_to :author, class_name: 'User'

  has_many :merge_request_assignees, dependent: :destroy
  has_many :assignees, through: :merge_request_assignees, source: :assignee

  has_many :merge_request_reviewers, dependent: :destroy
  has_many :reviewers, class_name: 'User', through: :merge_request_reviewers, source: :reviewer

  has_many :reviews, inverse_of: :merge_request, dependent: :destroy
  has_many :reviewed_by_users, -> { distinct }, through: :reviews, source: :author

  has_many :notes, as: :noteable, inverse_of: :noteable, dependent: :destroy
  has_many :diff_notes, -> { where(type: 'DiffNote') }, as: :noteable, class_name: 'DiffNote', dependent: :destroy

  after_update :clear_memoized_shas
  after_save :keep_around_commit, unless: :importing?

  validates :source_branch, presence: true
  validates :target_project, presence: true
  validates :target_branch, presence: true

  has_internal_id :iid, scope: :target_project, track_if: -> { !importing? },
    init: ->(mr, scope) do
      if mr
        mr.target_project&.merge_requests&.maximum(:iid)
      elsif scope[:project]
        where(target_project: scope[:project]).maximum(:iid)
      end
    end

  alias_method :project, :target_project
  alias_attribute :project_id, :target_project_id

  scope :by_source_or_target_branch, ->(branch_name) do
    where('source_branch = :branch OR target_branch = :branch', branch: branch_name)
  end

  scope :preload_project_and_latest_diff, -> { preload(:source_project, :latest_merge_request_diff) }
  scope :from_fork, -> { where('source_project_id <> target_project_id') }

  def self.ransackable_attributes(_auth_object = nil)
    %w[status author_id title]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[assignees reviewers]
  end

  def clear_memoized_shas
    @target_branch_sha = @source_branch_sha = nil

    clear_memoization(:source_branch_head)
    clear_memoization(:target_branch_head)
  end

  def keep_around_commit
    project.repository.keep_around(merge_commit_sha, source: self.class.name)
  end

  def self.merge_request_ref?(ref)
    ref.start_with?("refs/#{Repository::REF_MERGE_REQUEST}/")
  end

  def self.reference_prefix
    '!'
  end

  # `from` argument can be a Namespace or Project.
  def to_reference(from = nil, full: false)
    reference = "#{self.class.reference_prefix}#{iid}"

    "#{project.to_reference_base(from, full: full)}#{reference}"
  end

  def commits(limit: nil, load_from_gitaly: false, page: nil)
    commits_arr = if compare_commits
                    reversed_commits = compare_commits.reverse
                    limit ? reversed_commits.take(limit) : reversed_commits
                  else
                    []
                  end

    CommitCollection.new(source_project, commits_arr, source_branch)
  end

  def recent_commits(limit: MergeRequestDiff::COMMITS_SAFE_SIZE, load_from_gitaly: false, page: nil)
    commits(limit: limit, load_from_gitaly: load_from_gitaly, page: page)
  end

  def commits_count
    if compare_commits
      compare_commits.size
    else
      0
    end
  end

  def commit_shas(limit: nil)
    shas =
      if compare_commits
        compare_commits.to_a.reverse.map(&:sha)
      else
        Array(diff_head_sha)
      end

    limit ? shas.take(limit) : shas
  end

  def diffs(diff_options = {})
    compare.diffs(diff_options.merge(expanded: true))
  end

  MAX_RECENT_DIFF_HEAD_SHAS = 100

  def recent_diff_head_shas(limit = MAX_RECENT_DIFF_HEAD_SHAS)
    # see MergeRequestDiff.recent
    if merge_request_diffs.loaded?
      return merge_request_diffs.to_a.sort_by(&:id).reverse.first(limit).pluck(:head_commit_sha)
    end

    merge_request_diffs.recent(limit).pluck(:head_commit_sha)
  end

  def importing?
    false
  end

  def for_fork?
    target_project != source_project
  end

  def for_same_project?
    target_project == source_project
  end

  # Override from Noteable concern
  def discussions_resolvable?
    true
  end

  def project
    target_project
  end

  def reached_versions_limit?
    false
  end

  def reached_diff_commits_limit?
    false
  end
end
