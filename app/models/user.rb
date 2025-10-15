# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class User < ApplicationRecord
  extend Gitlab::ConfigHelper

  include Gitlab::ConfigHelper
  include HasUserType
  include Users::Authenticatable
  include Users::HasState
  include Users::CiTokenAuthenticatable
  include Users::Authorizable
  include Users::HasUploads

  FEED_TOKEN_PREFIX = 'glft-'

  has_many :keys
  has_many :project_members, -> { where(requested_at: nil) }
  has_many :projects, -> { distinct }, through: :project_members
  has_many :group_members, -> {
    where(requested_at: nil).where('access_level >= ?', Gitlab::Access::GUEST)
  }, class_name: 'GroupMember'
  has_many :groups, through: :group_members
  has_many :merge_request_assignees, dependent: :destroy, inverse_of: :assignee
  has_many :assigned_merge_requests, through: :merge_request_assignees, source: :merge_request
  has_many :merge_request_reviewers, inverse_of: :reviewer
  has_many :reviews, foreign_key: :author_id, inverse_of: :author
  has_many :work_item_assignees, inverse_of: :assignee, dependent: :destroy
  has_many :assigned_work_items, class_name: 'WorkItem', through: :work_item_assignees, source: :work_item
  # Todo, redirect to anonymouse
  # has_many :notes, foreign_key: :author_id, dependent: :destroy
  has_one :namespace, class_name: 'Namespaces::UserNamespace',
    required: true,
    dependent: :destroy,
    foreign_key: :creator_id,
    inverse_of: :creator,
    autosave: true

  before_validation :set_default_name
  before_validation :ensure_namespace, on: :create

  validates :username,
    presence: true,
    exclusion: { in: Gitlab::PathRegex::TOP_LEVEL_ROUTES, message: 'is a reserved name' }
  validates :namespace, presence: true

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :admins, -> { where(admin: true) }
  scope :active, -> { with_state(:active).non_internal }
  scope :blocked_pending_approval, -> { with_state(:blocked_pending_approval) }

  class << self
    def find_by_ssh_key_id(key_id)
      find_by('EXISTS (?)', Key.select(1).where('keys.user_id = users.id').auth.regular_keys.where(id: key_id))
    end

    def ransackable_attributes(_auth_object = nil)
      %w[name username]
    end

    def ransackable_associations(_auth_object = nil)
      %w[assigned_merge_requests merge_request_assignees merge_request_reviewers reviews]
    end
  end

  def can?(action, subject = :global, **)
    Ability.allowed?(self, action, subject, **)
  end

  def requires_ldap_check?
    false
  end

  def try_obtain_ldap_lease
    false
  end

  def has_composite_identity?
    false
  end

  def ci_job_token_scope_cache_key
    "users:#{id}:ci:job_token_scope"
  end

  def set_ci_job_token_scope!(job)
    Gitlab::SafeRequestStore[ci_job_token_scope_cache_key] = Ci::JobToken::Scope.new(job.project)
  end

  def required_terms_not_accepted?
    false
  end

  def can_admin_all_resources?
    can?(:admin_all_resources)
  end

  private

  def set_default_name
    self.name = username if name.nil?
  end

  def ensure_namespace
    ns = namespace || build_namespace(owner: self)
    ns.path = username
    ns.name = name
  end
end
