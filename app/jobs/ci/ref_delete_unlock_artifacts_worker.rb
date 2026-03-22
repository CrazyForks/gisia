# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  class RefDeleteUnlockArtifactsWorker < ApplicationJob
    queue_as :default

    def self.perform_async(project_id, user_id, ref)
    end

    def perform(project_id, user_id, ref)
    end
  end
end
