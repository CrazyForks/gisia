# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Route < ApplicationRecord
  belongs_to :namespace, inverse_of: :route

  before_save :downcase_path
  after_update :rename_children

  validates :path,
    length: { within: 1..255 },
    presence: true,
    uniqueness: { case_sensitive: false }

  def source
    namespace.resource
  end

  def source_id
    source&.id
  end

  private

  def downcase_path
    self.path = path.downcase
  end

  def rename_children
    return unless saved_change_to_path? || saved_change_to_name?

    namespace.all_children.each do |namespace|
      namespace.rebuild_route
      namespace.route.save!
    end
  end
end
