# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Routing
  module Projects
    module MembersHelper
      def project_members_url(project, *args)
        project_project_members_url(project, *args)
      end

      def project_member_path(project_member, *args)
        project_project_member_path(project_member.source, project_member)
      end

      def request_access_project_members_path(project, *args)
        request_access_project_project_members_path(project)
      end

      def leave_project_members_path(project, *args)
        leave_project_project_members_path(project)
      end

      def approve_access_request_project_member_path(project_member, *args)
        approve_access_request_project_project_member_path(project_member.source, project_member)
      end

      def resend_invite_project_member_path(project_member, *args)
        resend_invite_project_project_member_path(project_member.source, project_member)
      end
    end
  end
end
