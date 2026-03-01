# frozen_string_literal: true

module Projects
  module IssueAuthorizable
    extend ActiveSupport::Concern

    private

    def authorize_read_issues!
      authorization_denied! unless current_user.can?(:read_issue, @project)
    end

    def authorize_create_issue!
      authorization_denied! unless current_user.can?(:create_issue, @project)
    end

    def authorize_read_issuable!
      authorization_denied! unless current_user.can?(:read_issue, issuable_resource)
    end

    def authorize_update_issuable!
      authorization_denied! unless current_user.can?(:update_issue, issuable_resource)
    end

    def authorize_destroy_issuable!
      authorization_denied! unless current_user.can?(:destroy_issue, issuable_resource)
    end

    def authorization_denied!
      forbidden!
    end
  end
end
