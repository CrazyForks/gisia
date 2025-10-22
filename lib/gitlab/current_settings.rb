# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Gitlab
  module CurrentSettings
    class << self
      def signup_disabled?
        !signup_enabled?
      end

      def signup_limited?
        true
      end

      def current_application_settings
        Gitlab::SafeRequestStore.fetch(:current_application_settings) { Gitlab::ApplicationSettingFetcher.current_application_settings }
      end

      def current_application_settings?
        Gitlab::SafeRequestStore.exist?(:current_application_settings) || Gitlab::ApplicationSettingFetcher.current_application_settings?
      end

      def expire_current_application_settings
        Gitlab::ApplicationSettingFetcher.expire_current_application_settings
        Gitlab::SafeRequestStore.delete(:current_application_settings)
      end

      # -- Method calls are forwarded to one of the setting classes
      def method_missing(name, ...)
        application_settings = current_application_settings

        return application_settings.send(name, ...) if application_settings.respond_to?(name)

        if respond_to_organization_setting?(name, false)
          return ::Organizations::OrganizationSetting.for(::Current.organization.id).send(name, ...)
        end

        super
      end

      def respond_to_missing?(name, include_private = false)
        current_application_settings.respond_to?(name,
          include_private) || respond_to_organization_setting?(name, include_private) || super
      end

      def respond_to_organization_setting?(name, include_private)
        return false unless ::Current.organization_assigned

        ::Organizations::OrganizationSetting.for(::Current.organization.id).respond_to?(name, include_private)
      end
    end
  end
end
