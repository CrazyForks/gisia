# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  ##
  # This module implements methods that provide context in form of
  # essential CI/CD variables that can be used by a build / bridge job.
  #
  module Contextable
    extend MethodOverrideGuard
    ##
    # Variables in the environment name scope.
    #
    def scoped_variables(environment: expanded_environment_name, dependencies: true)
      pipeline
        .variables_builder
        .scoped_variables(self, environment: environment, dependencies: dependencies)
    end

    def unprotected_scoped_variables(
      expose_project_variables:,
      expose_group_variables:,
      environment: expanded_environment_name,
      dependencies: true
    )
      pipeline
        .variables_builder
        .unprotected_scoped_variables(
          self,
          expose_project_variables: expose_project_variables,
          expose_group_variables: expose_group_variables,
          environment: environment,
          dependencies: dependencies
        )
    end

    ##
    # Variables that do not depend on the environment name.
    #
    def simple_variables
      strong_memoize(:simple_variables) do
        scoped_variables(environment: nil)
      end
    end

    def manual_variables
      strong_memoize(:manual_variables) do
        respond_to?(:job_variables) ? job_variables : []
      end
    end

    def simple_variables_without_dependencies
      strong_memoize(:variables_without_dependencies) do
        scoped_variables(environment: nil, dependencies: false)
      end
    end
  end
end
