# frozen_string_literal: true

module Gitlab
  module WorkItems
    class WorkItemHierarchy
      def initialize(base, parents)
        @base = base
        @parents = parents
      end

      def cyclic?
        ::Gitlab::ObjectHierarchy.new(@parents).ancestors.exists?(id: @base.pluck(:id))
      end
    end
  end
end

