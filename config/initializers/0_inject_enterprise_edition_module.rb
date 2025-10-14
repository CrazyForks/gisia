# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

require 'active_support/inflector'

module InjectEnterpriseEditionModule
  def prepend_mod_with(constant_name, namespace: Object, with_descendants: false)
  end

  def extend_mod_with(constant_name, namespace: Object)
  end

  def include_mod_with(constant_name, namespace: Object)
  end

  def prepend_mod(with_descendants: false)
  end

  def extend_mod
  end

  def include_mod
  end
end

Module.prepend(InjectEnterpriseEditionModule)
