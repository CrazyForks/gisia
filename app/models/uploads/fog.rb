# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Uploads
  class Fog < Base
    include ::ObjectStorage::FogHelpers
    extend ::Gitlab::Utils::Override

    def keys(relation)
      return [] unless available?

      relation.pluck(:path)
    end

    def delete_keys(keys)
      keys.each { |key| delete_object(key) }
    end

    private

    override :storage_location_identifier
    def storage_location_identifier
      :uploads
    end
  end
end
