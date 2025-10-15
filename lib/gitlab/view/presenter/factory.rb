# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module View
    module Presenter
      class Factory
        def initialize(subject, **attributes)
          @subject = subject
          @attributes = attributes
        end

        def fabricate!
          presenter_class.new(subject, **attributes)
        end

        private

        attr_reader :subject, :attributes

        def presenter_class
          attributes.delete(:presenter_class) { "#{subject.class.name}Presenter".constantize }
        end
      end
    end
  end
end
