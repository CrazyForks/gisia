# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Ci
  module PredefinedVariables
    extend ActiveSupport::Concern
    include ::Gitlab::Utils::StrongMemoize

    def predefined_variables
      strong_memoize(:predefined_variables) do
        Gitlab::Ci::Variables::Collection.new
                                         .concat(predefined_ci_server_variables)
                                         .concat(predefined_project_variables)
                                         .concat(pages_variables)
                                         .concat(auto_devops_variables)
                                         .concat(api_variables)
                                         .concat(ci_template_variables)
      end
    end

    def predefined_project_variables
      strong_memoize(:predefined_project_variables) do
        Gitlab::Ci::Variables::Collection.new
                                         .append(key: 'GITLAB_FEATURES', value: licensed_features.join(','))
                                         .append(key: 'CI_PROJECT_ID', value: id.to_s)
                                         .append(key: 'CI_PROJECT_NAME', value: path)
                                         .append(key: 'CI_PROJECT_TITLE', value: title)
                                         .append(key: 'CI_PROJECT_DESCRIPTION', value: description)
                                         .append(key: 'CI_PROJECT_PATH', value: full_path)
                                         .append(key: 'CI_PROJECT_PATH_SLUG', value: full_path_slug)
                                         .append(key: 'CI_PROJECT_NAMESPACE', value: namespace.full_path)
                                         .append(key: 'CI_PROJECT_NAMESPACE_SLUG', value: Gitlab::Utils.slugify(namespace.full_path))
                                         .append(key: 'CI_PROJECT_NAMESPACE_ID', value: namespace.id.to_s)
                                         .append(key: 'CI_PROJECT_ROOT_NAMESPACE', value: namespace.root_ancestor.path)
                                         .append(key: 'CI_PROJECT_URL', value: web_url)
                                         .append(key: 'CI_PROJECT_VISIBILITY', value: ::Gitlab::VisibilityLevel.string_level(visibility_level))
                                         .append(key: 'CI_PROJECT_REPOSITORY_LANGUAGES', value: '')
                                         .append(key: 'CI_PROJECT_CLASSIFICATION_LABEL', value: nil)
                                         .append(key: 'CI_DEFAULT_BRANCH', value: default_branch)
                                         .append(key: 'CI_CONFIG_PATH', value: ci_config_path_or_default)
      end
    end

    def predefined_ci_server_variables
      Gitlab::Ci::Variables::Collection.new
                                       .append(key: 'CI', value: 'true')
                                       .append(key: 'GITLAB_CI', value: 'true')
                                       .append(key: 'CI_SERVER_FQDN', value: Gitlab.config.gitlab_ci.server_fqdn)
                                       .append(key: 'CI_SERVER_URL', value: Gitlab.config.gitlab.url)
                                       .append(key: 'CI_SERVER_HOST', value: Gitlab.config.gitlab.host)
                                       .append(key: 'CI_SERVER_PORT', value: Gitlab.config.gitlab.port.to_s)
                                       .append(key: 'CI_SERVER_PROTOCOL', value: Gitlab.config.gitlab.protocol)
                                       .append(key: 'CI_SERVER_SHELL_SSH_HOST', value: Gitlab.config.gitlab_shell.ssh_host.to_s)
                                       .append(key: 'CI_SERVER_SHELL_SSH_PORT', value: Gitlab.config.gitlab_shell.ssh_port.to_s)
                                       .append(key: 'CI_SERVER_NAME', value: 'GitLab')
                                       .append(key: 'CI_SERVER_VERSION', value: Gitlab::VERSION)
                                       .append(key: 'CI_SERVER_VERSION_MAJOR', value: Gitlab.version_info.major.to_s)
                                       .append(key: 'CI_SERVER_VERSION_MINOR', value: Gitlab.version_info.minor.to_s)
                                       .append(key: 'CI_SERVER_VERSION_PATCH', value: Gitlab.version_info.patch.to_s)
                                       .append(key: 'CI_SERVER_REVISION', value: Gitlab.revision)
    end

    def pages_variables
      Gitlab::Ci::Variables::Collection.new.tap do |variables|
        break unless pages_enabled?

        variables
          .append(key: 'CI_PAGES_DOMAIN', value: Gitlab.config.pages.host)
          .append(key: 'CI_PAGES_HOSTNAME', value: pages_hostname)
      end
    end

    def api_variables
      Gitlab::Ci::Variables::Collection.new.tap do |variables|
        variables.append(key: 'CI_API_V4_URL', value: API::Helpers::Version.new('v4').root_url)
      end
    end

    def ci_template_variables
      Gitlab::Ci::Variables::Collection.new.tap do |variables|
        variables.append(key: 'CI_TEMPLATE_REGISTRY_HOST', value: 'registry.gitlab.com')
      end
    end

    def auto_devops_variables
      []
    end
  end
end
