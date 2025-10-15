# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    module Type
      # Extends Rails' Jsonb data type to deserialize it into indifferent access Hash.
      #
      # Example:
      #
      #   class SomeModel < ApplicationRecord
      #     # some_model.a_field is of type `jsonb`
      #     attribute :a_field, ::Gitlab::Database::Type::IndifferentJsonb.new
      #   end
      class IndifferentJsonb < ::ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Jsonb
        def type
          :ind_jsonb
        end

        def deserialize(value)
          data = super
          return unless data

          ::Gitlab::Utils.deep_indifferent_access(data)
        end
      end
    end
  end
end
