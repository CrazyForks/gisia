# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Users
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      attribute :admin, default: false

      devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :confirmable, :lockable
    end

    # Todo,
    def confirmation_required_on_sign_in?
      return false if confirmed?

      false
    end

    def password_expired?
      !!(password_expires_at && password_expires_at.past?)
    end

    def password_expired_if_applicable?
      return false if bot?
      return false unless password_expired?
      return false if password_automatically_set?
      return false unless allow_password_authentication?

      true
    end

    def allow_password_authentication?
      allow_password_authentication_for_web? || allow_password_authentication_for_git?
    end

    def allow_password_authentication_for_web?
      true
    end

    def allow_password_authentication_for_git?
      true
    end

    def can_log_in_with_non_expired_password?
      can?(:log_in)
    end
  end
end
