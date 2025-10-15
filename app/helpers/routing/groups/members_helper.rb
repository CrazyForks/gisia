# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Routing
  module Groups
    module MembersHelper
      def group_members_url(group, *args)
        group_group_members_url(group, *args)
      end

      def group_member_path(group_member, *args)
        group_group_member_path(group_member.source, group_member)
      end

      def request_access_group_members_path(group, *args)
        request_access_group_group_members_path(group)
      end

      def leave_group_members_path(group, *args)
        leave_group_group_members_path(group)
      end

      def approve_access_request_group_member_path(group_member, *args)
        approve_access_request_group_group_member_path(group_member.source, group_member)
      end

      def resend_invite_group_member_path(group_member, *args)
        resend_invite_group_group_member_path(group_member.source, group_member)
      end
    end
  end
end
