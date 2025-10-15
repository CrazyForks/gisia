# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Encryption
    class KeyProviderWrapper
      attr_reader :key_provider

      def initialize(key_provider)
        @key_provider = key_provider
      end

      delegate :encryption_key, to: :key_provider

      def decryption_keys
        key_provider.decryption_keys(ActiveRecord::Encryption::Message.new)
      end
    end
  end
end
