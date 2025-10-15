# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module ProtectedRefs
  module Protectable
    extend ActiveSupport::Concern
    include Gitlab::Utils::StrongMemoize

    included do
      validates :name, presence: true
      validates :name, uniqueness: { scope: %i[namespace_id type] }, if: :name_changed?

      delegate :matching, :matches?, :wildcard?, to: :ref_matcher
    end

    class_methods do
      def allowed?(max_access, name)
        any? do |ref|
          ref.matches?(name) && ref.access_allowed?(max_access)
        end
      end

      # Returns all protected refs that match the given ref name.
      # This checks all records from the scope built up so far, and does
      # _not_ return a relation.
      #
      # This method optionally takes in a list of `protected_refs` to search
      # through, to avoid calling out to the database.
      def matches?(name, protected_refs: nil)
        (protected_refs || all).any? { |ref| ref.matches?(name) }
      end
    end

    def access_allowed?(max_access)
      max_access >= access_level_before_type_cast
    end

    private

    def ref_matcher
      strong_memoize_with(:ref_matcher, name) do
        RefMatcher.new(name)
      end
    end
  end
end
