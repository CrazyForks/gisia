# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Expirable
  extend ActiveSupport::Concern

  DAYS_TO_EXPIRE = 7

  included do
    scope :expired, -> { where(arel_table[:expires_at].lteq(Time.current)) }
    scope :not_expired, -> { where(arel_table[:expires_at].gt(Time.current)).or(where(expires_at: nil)) }
  end

  def expired?
    expires? && expires_at <= Time.current
  end

  # Used in subclasses that override expired?
  alias_method :expired_original?, :expired?

  def expires?
    expires_at.present?
  end

  def expires_soon?
    expires? && expires_at < DAYS_TO_EXPIRE.days.from_now
  end
end
