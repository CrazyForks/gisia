# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Routing
  module MembersHelper
    def source_members_url(member)
      case member.source_type
      when 'Namespace'
        group_group_members_url(member.source)
      when 'Project'
        project_project_members_url(member.source)
      end
    end
  end
end
