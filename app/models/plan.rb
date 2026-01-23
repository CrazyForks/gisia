# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================


class Plan < ApplicationRecord
  DEFAULT = 'default'

  has_one :limits, class_name: 'PlanLimits'

  scope :by_name, ->(name) { where(name: name) }

  ALL_PLANS = [DEFAULT].freeze
  DEFAULT_PLANS = [DEFAULT].freeze
  private_constant :ALL_PLANS, :DEFAULT_PLANS

  # This always returns an object
  def self.default
    Gitlab::SafeRequestStore.fetch(:plan_default) do
      # find_by allows us to find object (cheaply) against replica DB
      # safe_find_or_create_by does stick to primary DB
      find_by(name: DEFAULT) || safe_find_or_create_by(name: DEFAULT) { |plan| plan.title = DEFAULT.titleize }
    end
  end

  def self.all_plans
    ALL_PLANS
  end

  def self.default_plans
    DEFAULT_PLANS
  end

  # -- This method is prepared for manual usage in
  # Rails console on SaaS. Using pluck without limit in this case should be enough safe.
  def self.ids_for_names(names)
    where(name: names).pluck(:id)
  end

  # -- This method is prepared for manual usage in
  # Rails console on SaaS. Using pluck without limit in this case should be enough safe.
  def self.names_for_ids(plan_ids)
    id_in(plan_ids).pluck(:name)
  end

  def actual_limits
    limits || build_limits
  end

  def default?
    self.class.default_plans.include?(name)
  end

  def paid?
    false
  end
end

