# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    module LoadBalancing
      module ActionCableCallbacks
        def self.install
          ::ActionCable::Server::Worker.set_callback :work, :around, &wrapper
        end

        def self.wrapper
          ->(_, inner) do
            inner.call
          ensure
            ::Gitlab::Database::LoadBalancing.release_hosts
            ::Gitlab::Database::LoadBalancing::SessionMap.clear_session
          end
        end
      end
    end
  end
end
