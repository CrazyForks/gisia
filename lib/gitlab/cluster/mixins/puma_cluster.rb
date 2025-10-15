# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Cluster
    module Mixins
      module PumaCluster
        def self.prepended(base)
          raise 'missing method Puma::Cluster#stop_workers' unless base.method_defined?(:stop_workers)
        end

        # This looks at internal status of `Puma::Cluster`
        # https://github.com/puma/puma/blob/v3.12.1/lib/puma/cluster.rb#L333
        def stop_workers
          if @status == :stop # rubocop:disable Gitlab/ModuleWithInstanceVariables
            Gitlab::Cluster::LifecycleEvents.do_before_graceful_shutdown
          end

          super
        end
      end
    end
  end
end
