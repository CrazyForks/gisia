# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

require 'active_job/arguments'

module MailScheduler
  class NotificationServiceJob < ApplicationJob
    queue_as :default

    def perform(meth, *serialized_args)
      return unless NotificationService.permitted_actions.include?(meth.to_sym)

      args = ActiveJob::Arguments.deserialize(serialized_args)
      NotificationService.new.public_send(meth, *args)
    rescue ActiveJob::DeserializationError
    end

    def self.perform_async(meth, *args)
      perform_later(meth, *ActiveJob::Arguments.serialize(args))
    end
  end
end
