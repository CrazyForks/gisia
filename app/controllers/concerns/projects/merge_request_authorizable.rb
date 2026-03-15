# frozen_string_literal: true

module Projects
  module MergeRequestAuthorizable
    extend ActiveSupport::Concern

    private

    def authorize_read_merge_requests!
      forbidden! unless current_user.can?(:read_merge_request, @project)
    end

    def authorize_create_merge_request!
      forbidden! unless current_user.can?(:create_merge_request_in, @project)
    end

    def authorize_read_merge_request!
      forbidden! unless current_user.can?(:read_merge_request, @merge_request)
    end

    def authorize_update_merge_request!
      forbidden! unless current_user.can?(:update_merge_request, @merge_request)
    end

    def authorize_destroy_merge_request!
      forbidden! unless current_user.can?(:destroy_merge_request, @merge_request)
    end
  end
end
