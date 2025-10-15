# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# Class that returns the disk path for a model using hashed storage

module Gitlab
  class HashedPath
    def initialize(*paths, root_hash:)
      @paths = paths
      @root_hash = root_hash
    end

    def to_s
      File.join(disk_hash[0..1], disk_hash[2..3], disk_hash, @paths.map(&:to_s))
    end

    alias_method :to_str, :to_s

    private

    def disk_hash
      @disk_hash ||= Digest::SHA2.hexdigest(@root_hash.to_s)
    end
  end
end
