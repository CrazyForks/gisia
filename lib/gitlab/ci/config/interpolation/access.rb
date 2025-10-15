# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Ci
    class Config
      module Interpolation
        class Access
          attr_reader :content, :errors

          MAX_ACCESS_OBJECTS = 5
          MAX_ACCESS_BYTESIZE = 1024

          def initialize(access, ctx)
            @content = access
            @ctx = ctx
            @errors = []

            if objects.count <= 1
              @errors.push('invalid pattern used for interpolation. valid pattern is $[[ inputs.input ]]')
            end

            if access.bytesize > MAX_ACCESS_BYTESIZE # rubocop:disable Style/IfUnlessModifier
              @errors.push('maximum interpolation expression size exceeded')
            end

            evaluate! if valid?
          end

          def valid?
            errors.none?
          end

          def objects
            @objects ||= @content.split('.', MAX_ACCESS_OBJECTS)
          end

          def value
            raise ArgumentError, 'access path invalid' unless valid?

            @value
          end

          private

          def evaluate!
            raise ArgumentError, 'access path invalid' unless valid?

            @value ||= objects.inject(@ctx) do |memo, value|
              key = value.to_sym

              unless memo.respond_to?(:key?) && memo.key?(key)
                break @errors.push("unknown input name provided: `#{key}` in `#{@content}`")
              end

              memo.fetch(key)
            end
          end
        end
      end
    end
  end
end
