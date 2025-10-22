# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class ApplicationSetting < ApplicationRecord
  include CacheableAttributes
  include TokenAuthenticatable
  include Sanitizable
  include Gitlab::EncryptedAttribute
  include SafelyChangeColumnDefault
  include IgnorableColumns

  # We won't add a prefix here as this token is deprecated and being
  # disabled in 17.0
  # https://docs.gitlab.com/ee/ci/runners/new_creation_workflow.html
  add_authentication_token_field :runners_registration_token, encrypted: :required

  sanitizes! :default_branch_name

  jsonb_accessor :ci_cd_settings,
    pipeline_variables_default_allowed: [:boolean, { default: true }],
    ci_job_live_trace_enabled: [:boolean, { default: false }],
    ci_partitions_size_limit: [::Gitlab::Database::Type::JsonbInteger.new, { default: 100.gigabytes }],
    ci_delete_pipelines_in_seconds_limit: [:integer, { default: 1.year.to_i }],
    git_push_pipeline_limit: [:integer, { default: 4 }]

  before_validation :normalize_default_branch_name
  before_save :ensure_runners_registration_token

  # Restricting the validation to `on: :update` only to avoid cyclical dependencies with
  # License <--> ApplicationSetting. This method calls a license check when we create
  # ApplicationSetting from defaults which in turn depends on ApplicationSetting record.
  # The correct default is defined in the `defaults` method so we don't need to validate
  # it here.
  validates :disable_feed_token,
    inclusion: { in: [true, false], message: N_('must be a boolean value') }, on: :update

  validates :enabled_git_access_protocol,
    inclusion: { in: %w[ssh http], allow_blank: true }
  validates :gitlab_dedicated_instance,
    allow_nil: false,
    inclusion: { in: [true, false], message: N_('must be a boolean value') }

  validates :admin_mode,
    inclusion: { in: [true, false], message: N_('must be a boolean value') }
  validates :allow_runner_registration_token,
    allow_nil: false,
    inclusion: { in: [true, false], message: N_('must be a boolean value') }
  validate :check_valid_runner_registrars

  validates :hashed_storage_enabled,
    inclusion: { in: [true], message: N_("Hashed storage can't be disabled anymore for new projects") }

  validates :diff_max_patch_bytes,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: Gitlab::Git::Diff::DEFAULT_MAX_PATCH_BYTES,
      less_than_or_equal_to: Gitlab::Git::Diff::MAX_PATCH_BYTES_UPPER_BOUND
    }

  validates :diff_max_files,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: Commit::DEFAULT_MAX_DIFF_FILES_SETTING,
      less_than_or_equal_to: Commit::MAX_DIFF_FILES_SETTING_UPPER_BOUND
    }

  validates :diff_max_lines,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: Commit::DEFAULT_MAX_DIFF_LINES_SETTING,
      less_than_or_equal_to: Commit::MAX_DIFF_LINES_SETTING_UPPER_BOUND
    }

  with_options(numericality: { only_integer: true, greater_than: 0 }) do
    validates :max_attachment_size
  end

  # Include here so it can override methods from
  # `add_authentication_token_field`
  # We don't prepend for now because otherwise we'll need to
  # fix a lot of tests using allow_any_instance_of
  include ApplicationSettingImplementation

  def normalize_default_branch_name
    self.default_branch_name = default_branch_name.presence
  end

  Recursion = Class.new(RuntimeError)

  def self.create_from_defaults
    # this is possible if calls to create the record depend on application
    # settings themselves. This was seen in the case of a feature flag called by
    # `transaction` that ended up requiring application settings to determine metrics behavior.
    # If something like that happens, we break the loop here, and let the caller decide how to manage it.
    raise Recursion if Thread.current[:application_setting_create_from_defaults]

    Thread.current[:application_setting_create_from_defaults] = true

    check_schema!

    transaction(requires_new: true) do
      super
    end
  rescue ActiveRecord::RecordNotUnique
    # We already have an ApplicationSetting record, so just return it.
    current_without_cache
  ensure
    Thread.current[:application_setting_create_from_defaults] = nil
  end

  def self.find_or_create_without_cache
    current_without_cache || create_from_defaults
  end

  # Due to the frequency with which settings are accessed, it is
  # likely that during a backup restore a running GitLab process
  # will insert a new `application_settings` row before the
  # constraints have been added to the table. This would add an
  # extra row with ID 1 and prevent the primary key constraint from
  # being added, which made ActiveRecord throw a
  # IrreversibleOrderError anytime the settings were accessed
  # (https://gitlab.com/gitlab-org/gitlab/-/issues/36405).  To
  # prevent this from happening, we do a sanity check that the
  # primary key constraint is present before inserting a new entry.
  def self.check_schema!
    return if connection.primary_key(table_name).present?

    raise "The `#{table_name}` table is missing a primary key constraint in the database schema"
  end

  # By default, the backend is Rails.cache, which uses
  # ActiveSupport::Cache::RedisStore. Since loading ApplicationSetting
  # can cause a significant amount of load on Redis, let's cache it in
  # memory.
  def self.cache_backend
    Gitlab::ProcessMemoryCache.cache_backend
  end
end
