# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# Represents Dag pipeline
module Gitlab
  module Ci
    class YamlProcessor
      class Dag
        include TSort

        def initialize(nodes)
          @nodes = nodes
        end

        def self.order(jobs)
          new(jobs).tsort
        end

        def self.check_circular_dependencies!(jobs)
          new(jobs).tsort
        rescue TSort::Cyclic => e
          raise ValidationError, "The pipeline has circular dependencies: #{e.message}"
        end

        def tsort_each_child(node, &block)
          return unless @nodes[node]

          raise TSort::Cyclic, "self-dependency: #{node}" if @nodes[node].include?(node)

          @nodes[node].each(&block)
        end

        def tsort_each_node(&block)
          @nodes.each_key(&block)
        end
      end
    end
  end
end
