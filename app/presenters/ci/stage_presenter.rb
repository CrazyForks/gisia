# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Ci
  class StagePresenter < Gitlab::View::Presenter::Delegated
    presents ::Ci::Stage, as: :stage

    PRELOADED_RELATIONS = [:pipeline, :metadata, :tags, :job_artifacts_archive, :downstream_pipeline].freeze

    def latest_ordered_statuses
      preload_statuses(stage.statuses.latest_ordered)
    end

    def retried_ordered_statuses
      preload_statuses(stage.statuses.retried_ordered)
    end

    private

    def preload_statuses(statuses)
      Preloaders::CommitStatusPreloader.new(statuses).execute(PRELOADED_RELATIONS)

      statuses
    end
  end
end
