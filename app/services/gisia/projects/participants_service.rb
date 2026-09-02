# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module Gisia
  module Projects
    # Prepended onto ::Projects::ParticipantsService.
    #
    # The upstream bodies these override are still present in those files. They
    # are unreachable (nothing here calls `super`) and kept as the reference for
    # what to restore as each dependency lands.
    module ParticipantsService
      # Upstream also mixes in authorized groups and per-organization user
      # details. Gisia has neither, so the participant set is the noteable's
      # author, its participants, `@all` and the project members.
      #
      # Upstream only applies the search to `project_members` and leaves the rest
      # for its client-side fuzzy matcher to narrow. Gisia renders the menu on the
      # server, so the whole list is filtered here instead.
      def execute(noteable)
        @noteable = noteable

        participants =
          noteable_owner +
          participants_in_noteable +
          all_members +
          project_members

        render_participants_as_hash(filter_by_search(participants.uniq))
      end

      # Upstream uses `project.authorized_users`, which resolves membership
      # through group and shared-project links Gisia does not model yet.
      def project_members_relation
        project.team.users.active
      end

      private

      def filter_by_search(participants)
        return participants if params[:search].blank?

        query = params[:search].to_s.downcase

        participants.select { |participant| searchable_text(participant).any? { |text| text.include?(query) } }
      end

      # `all_members` yields a Hash, the rest yield User records.
      def searchable_text(participant)
        values =
          if participant.is_a?(Hash)
            participant.values_at(:username, :name)
          else
            [participant.username, participant.name]
          end

        values.map { |value| value.to_s.downcase }
      end

      # Upstream searches with the `gfm_autocomplete_search` scope, which Gisia
      # does not define. Ransack gives the same prefix/substring behaviour.
      def filter_and_sort_users(users_relation)
        return sorted(users_relation) if params[:search].blank?

        users_relation
          .ransack(username_or_name_cont: params[:search])
          .result
          .limit(::Users::ParticipableService::SEARCH_LIMIT)
      end

      # Upstream batch-loads availability from UserStatus, which is not ported.
      # `user_as_hash` calls `.itself` on the result, so nil is safe.
      def lazy_user_availability(user); end

      # Upstream also maps Organizations::OrganizationUserDetail, which does not
      # exist here.
      def participant_as_hash(participant)
        case participant
        when Group
          group_as_hash(participant)
        when User
          user_as_hash(participant)
        else
          participant
        end
      end
    end
  end
end

