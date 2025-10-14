# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

require 'active_support'
require 'active_support/core_ext/hash'

require_relative 'gitlab_settings/settings'
require_relative 'gitlab_settings/options'

module GitlabSettings
  MissingSetting = Class.new(StandardError)

  def self.load(source = nil, section = nil, &block)
    ::GitlabSettings::Settings
    .new(source, section)
    .extend(Module.new(&block))
  end
end
