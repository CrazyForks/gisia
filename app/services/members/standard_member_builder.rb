# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Members
  class StandardMemberBuilder
    def initialize(source, invitee, existing_members)
      @source = source
      @invitee = invitee
      @existing_members = existing_members
    end

    def execute
      find_or_initialize_member_by_user(invitee.id)
    end

    private

    attr_reader :source, :invitee, :existing_members

    def find_or_initialize_member_by_user(user_id)
      existing_members[user_id] || source.members_and_requesters.build(user_id: user_id)
    end
  end
end
