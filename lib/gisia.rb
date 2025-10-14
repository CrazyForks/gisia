# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

require 'pathname'
require 'forwardable'

require_relative 'gitlab_edition'

module Gisia
  class << self
    extend Forwardable

    def_delegators :GitlabEdition, :root
  end

  VERSION = File.read(root.join('GISIA_VERSION')).strip.freeze
end
