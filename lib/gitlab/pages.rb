# frozen_string_literal: true

module Gitlab
  module Pages
    class << self
      def access_control_is_forced?
        true
      end

      def enabled?
        false
      end
    end
  end
end
