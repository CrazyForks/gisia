# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Database
    module Type
      # Extends Rails' Jsonb data type to deserialize it into symbolized Hash.
      #
      # Example:
      #
      #   class SomeModel < ApplicationRecord
      #     # some_model.a_field is of type `jsonb`
      #     attribute :a_field, ::Gitlab::Database::Type::SymbolizedJsonb.new
      #   end
      class SymbolizedJsonb < ::ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Jsonb
        def type
          :sym_jsonb
        end

        def deserialize(value)
          data = super
          return unless data

          ::Gitlab::Utils.deep_symbolized_access(data)
        end
      end
    end
  end
end
