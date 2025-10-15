# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# == GitLab Shell mixin
#
# Provide a shortcut to Gitlab::Shell instance by gitlab_shell
#
module Gitlab
  module ShellAdapter
    def gitlab_shell
      @gitlab_shell ||= Gitlab::Shell.new
    end
  end
end
