# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module InternalEvents
    class EventsRouter
      include Gitlab::Utils::StrongMemoize

      def initialize(event_name, additional_properties, kwargs)
        @event_name = event_name
        @additional_properties = additional_properties
        @kwargs = kwargs
      end

      def public_additional_properties
        public_properties = event_definition.additional_properties.keys
        additional_properties.slice(*public_properties)
      end

      def event_definition
        Gitlab::Tracking::EventDefinition.find(event_name)
      end
      strong_memoize_attr :event_definition

      def extra_tracking_data(properties)
        additional_properties.slice(*properties[:protected_properties])
          .merge(public_additional_properties)
          .merge(kwargs)
      end

      private

      attr_accessor :event_name, :additional_properties, :kwargs
    end
  end
end
