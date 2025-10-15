# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  module NewHasVariable
    extend ActiveSupport::Concern
    include Ci::HasVariable

    included do
      include Gitlab::EncryptedAttribute

      attr_encrypted :value,
        mode: :per_attribute_iv,
        algorithm: 'aes-256-gcm',
        key: :db_key_base_32,
        insecure_mode: false
    end
  end
end
