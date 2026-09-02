# frozen_string_literal: true

module Gisia
  module Notes
    # Prepended onto ::Notes::QuickActionsService.
    #
    # The upstream bodies these override are still present in that file. They are
    # unreachable (nothing here calls `super`) and kept as the reference for what
    # to restore as each service lands.
    module QuickActionsService
      private

      # Upstream fans out to GraphQL subscriptions. Gisia has none.
      def trigger_work_item_updated(note, params); end

      # Upstream dispatches to WorkItems::/Issues::/MergeRequests::UpdateService or
      # Commits::TagService. None are ported, so the state events that are the only
      # commands wired up for notes are applied by StateEventUpdater, which honours
      # the same `execute(noteable)` contract.
      def noteable_update_service(_note, update_params)
        StateEventUpdater.new(current_user: current_user, params: update_params)
      end

      # Returns the noteable either way, so the error handling in
      # `execute_update_service` stays identical to upstream: a failed transition
      # surfaces through `noteable.errors` exactly as a failed update would.
      class StateEventUpdater
        def initialize(current_user:, params:)
          @current_user = current_user
          @params = params
        end

        def execute(noteable)
          assign_author(noteable)

          case @params[:state_event]
          when 'close' then noteable.close!(@current_user)
          when 'reopen' then noteable.reopen!
          end

          noteable
        rescue StateMachines::InvalidTransition => e
          # state_machines has usually recorded its own error on the noteable already
          noteable.errors.add(:base, e.message) if noteable.errors.empty?
          noteable
        end

        private

        def assign_author(noteable)
          noteable.notification_author = @current_user if noteable.respond_to?(:notification_author=)
          noteable.activity_author = @current_user if noteable.respond_to?(:activity_author=)
        end
      end
    end
  end
end

