# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

constraints(::Constraints::GroupUrlConstrainer.new) do
  get '*namespace_id', to: 'namespaces/namespaces#show', as: :namespace_show,
    constraints: { namespace_id: Gitlab::PathRegex.full_namespace_route_regex }
end

constraints(::Constraints::UserUrlConstrainer.new) do
  get '*namespace_id', to: 'namespaces/namespaces#show',
    constraints: { namespace_id: Gitlab::PathRegex.full_namespace_route_regex }
end
