# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module Yaml
        module Tags
          # This class is the entry point for transforming custom YAML tags back
          # into primitive objects.
          # Usage: `Resolver.new(a_hash_including_custom_tag_objects).to_hash`
          #
          class Resolver
            attr_reader :config

            def initialize(config)
              @config = config.deep_dup
            end

            def to_hash
              deep_resolve(config)
            end

            def deep_resolve(object)
              case object
              when Array
                object.map(&method(:resolve_wrapper))
              when Hash
                object.deep_transform_values(&method(:resolve_wrapper))
              else
                resolve_wrapper(object)
              end
            end

            def resolve_wrapper(object)
              if object.respond_to?(:resolve)
                object.resolve(self)
              else
                object
              end
            end
          end
        end
      end
    end
  end
end
