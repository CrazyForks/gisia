# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module ActionCable
    module IpAddressStateCallback
      def self.install
        ::ActionCable::Server::Worker.set_callback :work, :around, &wrapper
      end

      def self.wrapper
        ->(_, inner) do
          ::Gitlab::IpAddressState.with(connection.request.ip) do # rubocop: disable CodeReuse/ActiveRecord -- not an ActiveRecord object
            inner.call
          end
        end
      end
    end
  end
end
