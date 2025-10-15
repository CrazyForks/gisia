# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Importable
  extend ActiveSupport::Concern

  attr_accessor :user_contributions
  attr_accessor :importing
  alias_method :importing?, :importing
end
