# frozen_string_literal: true

module Projects
  module MergeRequestNotifiable
    extend ActiveSupport::Concern

    private

    def handle_state_event(state_event)
      case state_event
      when 'close'
        unless @merge_request.closed?
          @merge_request.closing_user = current_user
          @merge_request.close!
        end
      when 'reopen' then @merge_request.reopen unless @merge_request.opened?
      end
    end

    def notify_mr_update(state_event, previous_assignee_ids)
      ns = NotificationService.new
      case state_event
      when 'close'  then ns.close_mr(@merge_request, current_user)
      when 'reopen' then ns.reopen_mr(@merge_request, current_user)
      end

      notify_reassigned_merge_request(previous_assignee_ids)
    end

    def notify_reassigned_merge_request(previous_assignee_ids)
      return unless previous_assignee_ids

      current_ids = @merge_request.assignees.map(&:id).sort
      return if current_ids == previous_assignee_ids

      NotificationService.new.reassigned_merge_request(@merge_request, current_user, User.where(id: previous_assignee_ids))
    end
  end
end
