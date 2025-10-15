# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  class PendingBuild < Ci::ApplicationRecord
    include EachBatch

    attr_accessor :partition_id

    belongs_to :project

    belongs_to :build, class_name: 'Ci::Build'
    belongs_to :namespace, inverse_of: :pending_builds, class_name: 'Namespace'
    belongs_to :plan, optional: true

    validates :namespace, presence: true

    scope :ref_protected, -> { where(protected: true) }
    scope :with_instance_runners, -> { where(instance_runners_enabled: true) }
    scope :for_tags, ->(tag_ids) do
      if tag_ids.present?
        where("ci_pending_builds.tag_ids <@ '{?}'", Array.wrap(tag_ids))
      else
        where("ci_pending_builds.tag_ids = '{}'")
      end
    end

    class << self
      def upsert_from_build!(build)
        entry = new(args_from_build(build))

        entry.validate!

        upsert(entry.attributes.compact, returning: %w[build_id], unique_by: :build_id)
      end

      def namespace_transfer_params(namespace)
        {
          namespace_traversal_ids: namespace.traversal_ids,
          namespace_id: namespace.id
        }
      end

      private

      def args_from_build(build)
        project = build.project

        args = {
          build: build,
          project: project,
          protected: build.protected?,
          namespace: project.namespace,
          tag_ids: build.tags_ids,
          instance_runners_enabled: shared_runners_enabled?(project)
        }

        args.store(:namespace_traversal_ids, project.namespace.traversal_ids) if group_runners_enabled?(project)

        args
      end

      def shared_runners_enabled?(project)
        builds_enabled?(project) && project.shared_runners_enabled?
      end

      def group_runners_enabled?(project)
        builds_enabled?(project) && project.group_runners_enabled?
      end

      def builds_enabled?(project)
        project.builds_enabled? && !project.pending_delete?
      end
    end
  end
end

Ci::PendingBuild.prepend_mod_with('Ci::PendingBuild')
