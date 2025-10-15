# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module GitalyClient
    # This module expects an `ATTRS` const to be defined on the subclass
    # See GitalyClient::WikiPage for an example
    module AttributesBag
      extend ActiveSupport::Concern

      included do
        attr_accessor(*const_get(:ATTRS, false))
      end

      def initialize(params)
        params = params.with_indifferent_access

        attributes.each do |attr|
          instance_variable_set("@#{attr}", params[attr])
        end
      end

      def ==(other)
        attributes.all? do |field|
          instance_variable_get("@#{field}") == other.instance_variable_get("@#{field}")
        end
      end

      def attributes
        self.class.const_get(:ATTRS, false)
      end
    end
  end
end
