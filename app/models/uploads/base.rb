# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Uploads
  class Base
    BATCH_SIZE = 100

    attr_reader :logger

    def initialize(logger: nil)
      @logger = Gitlab::AppLogger
    end

    def delete_keys_async(keys_to_delete)
      keys_to_delete.each_slice(BATCH_SIZE) do |batch|
        DeleteStoredFilesWorker.perform_async(self.class.name, batch)
      end
    end
  end
end
