# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# PublicUrlValidator
#
# Custom validator for URLs. This validator works like AddressableUrlValidator but
# it blocks by default urls pointing to localhost or the local network.
#
# This validator accepts the same params UrlValidator does.
#
# Example:
#
#   class User < ActiveRecord::Base
#     validates :personal_url, public_url: true
#
#     validates :ftp_url, public_url: { schemes: %w(ftp) }
#
#     validates :git_url, public_url: { allow_localhost: true, allow_local_network: true}
#   end
#
class PublicUrlValidator < AddressableUrlValidator
  DEFAULT_OPTIONS = {
    allow_localhost: false,
    allow_local_network: false
  }.freeze

  def initialize(options)
    options.reverse_merge!(DEFAULT_OPTIONS)

    super(options)
  end
end
