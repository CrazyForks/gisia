# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

class ProtectedBranch::CacheKey # rubocop:disable Style/ClassAndModuleChildren -- Same problem as in push_access_level.rb
  include Gitlab::Utils::StrongMemoize

  CACHE_ROOT_KEY = 'cache:gitlab:protected_branch'

  def initialize(entity)
    @entity = entity
  end

  def to_s
    [CACHE_ROOT_KEY, entity_scope, entity.id].join(':')
  end

  private

  attr_reader :entity

  def entity_scope
    case entity
    when Group
      'group'
    when Project
      'project'
    else
      entity.class.name.downcase
    end
  end
end
