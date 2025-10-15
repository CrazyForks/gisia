# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Encryption
    class NonDerivedKeyProvider < ActiveRecord::Encryption::KeyProvider
      def initialize(passwords)
        super(Array(passwords).collect { |password| ActiveRecord::Encryption::Key.new(password) })
      end
    end
  end
end
