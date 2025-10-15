# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Checksummable
  extend ActiveSupport::Concern

  class_methods do
    def crc32(data)
      Zlib.crc32(data)
    end

    def sha256_hexdigest(path)
      ::Digest::SHA256.file(path).hexdigest
    end

    def md5_hexdigest(path)
      ::Digest::MD5.file(path).hexdigest
    end
  end
end
