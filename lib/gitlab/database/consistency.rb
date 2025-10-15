# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    ##
    # This class is used to make it possible to ensure read consistency in
    # GitLab without the need of overriding a lot of methods / classes /
    # classs.
    #
    class Consistency
      ##
      # Within the block, disable the database load balancing for calls that
      # require read consistency after recent writes.
      #
      def self.with_read_consistency(&block)
        ::Gitlab::Database::LoadBalancing::SessionMap
          .with_sessions(Gitlab::Database::LoadBalancing.base_models)
          .use_primary(&block)
      end
    end
  end
end
