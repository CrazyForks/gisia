# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  # This model represents metadata for a running build.
  class RunningBuild < Ci::ApplicationRecord
    attr_accessor :partition_id

    belongs_to :project
    belongs_to :build, class_name: 'Ci::Build'
    belongs_to :runner, class_name: 'Ci::Runner'

    enum :runner_type, ::Ci::Runner.runner_types

    def self.upsert_build!(build)
      raise ArgumentError, 'build has not been picked by a runner' if build.runner.nil?

      # Owner namespace of the runner that executed the build
      runner_owner_namespace_id = build.runner.owner_runner_namespace.namespace_id if build.runner.group_type?

      entry = new(
        build: build,
        project: build.project,
        runner: build.runner,
        runner_type: build.runner.runner_type,
        runner_owner_namespace_xid: runner_owner_namespace_id
      )

      entry.validate!

      upsert(entry.attributes.compact, returning: %w[build_id], unique_by: :build_id)
    end
  end
end
