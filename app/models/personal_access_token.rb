# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class PersonalAccessToken < ApplicationRecord
  include Expirable
  include TokenAuthenticatable
  include Sortable
  include EachBatch
  include CreatedAtFilterable
  include Gitlab::SQL::Pattern

  AVAILABLE_SCOPES = %i[api read_api].freeze
  MAX_PERSONAL_ACCESS_TOKEN_LIFETIME_IN_DAYS = 365

  serialize :scopes, coder: YAML, type: Array

  add_authentication_token_field :token,
    digest: true,
    format_with_prefix: :prefix_from_application_current_settings

  belongs_to :user

  has_many :last_used_ips, class_name: 'PersonalAccessTokenLastUsedIp', dependent: :destroy

  after_initialize :set_default_scopes, if: :persisted?
  before_save :ensure_token

  scope :active, -> { not_revoked.not_expired }
  scope :inactive, -> { where("revoked = true OR expires_at < CURRENT_DATE") }
  scope :revoked, -> { where(revoked: true) }
  scope :not_revoked, -> { where(revoked: [false, nil]) }
  scope :for_user, ->(user) { where(user: user) }
  scope :expires_before, ->(date) { where(arel_table[:expires_at].lt(date)) }
  scope :expires_after, ->(date) { where(arel_table[:expires_at].gteq(date)) }
  scope :last_used_before, ->(date) { where("last_used_at <= ?", date) }
  scope :last_used_after, ->(date) { where("last_used_at >= ?", date) }
  scope :order_expires_at_asc_id_desc, -> { reorder(expires_at: :asc, id: :desc) }
  scope :order_expires_at_desc_id_desc, -> { reorder(expires_at: :desc, id: :desc) }
  scope :order_last_used_at_asc_id_desc, -> { reorder(last_used_at: :asc, id: :desc) }
  scope :order_last_used_at_desc_id_desc, -> { reorder(last_used_at: :desc, id: :desc) }
  scope :with_token_digests, ->(digests) { where(token_digest: digests) }
  scope :with_impersonation, -> { none }
  scope :without_impersonation, -> { where({}) }

  validates :name, :scopes, presence: true
  validates :expires_at, presence: true, on: :create, unless: :allow_expires_at_to_be_empty?
  validate :validate_scopes

  def revoke!
    if persisted?
      update_columns(revoked: true, updated_at: Time.zone.now)
    else
      self.revoked = true
    end
  end

  def active?
    !revoked? && !expired?
  end

  def self.simple_sorts
    super.merge(
      'expires_asc' => -> { order_expires_at_asc_id_desc },
      'expires_desc' => -> { order_expires_at_desc_id_desc },
      'last_used_asc' => -> { order_last_used_at_asc_id_desc },
      'last_used_desc' => -> { order_last_used_at_desc_id_desc }
    )
  end

  def self.token_prefix
    Gitlab::CurrentSettings.current_application_settings.personal_access_token_prefix
  end

  def self.search(query)
    fuzzy_search(query, [:name])
  end

  def update_last_used!
    return if last_used_at.present? && last_used_at > 10.minutes.ago

    update_columns(last_used_at: Time.zone.now)
  end

  protected

  def validate_scopes
    return if revoked

    unless scopes.all? { |scope| AVAILABLE_SCOPES.include?(scope.to_sym) }
      errors.add :scopes, "can only contain available scopes"
    end
  end

  def set_default_scopes
    return unless has_attribute?(:scopes)

    self.scopes = [:api] if scopes.blank?
  end

  def prefix_from_application_current_settings
    self.class.token_prefix
  end

  def allow_expires_at_to_be_empty?
    !Gitlab::CurrentSettings.require_personal_access_token_expiry?
  end
end
