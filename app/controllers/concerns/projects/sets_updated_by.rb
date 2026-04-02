# frozen_string_literal: true

module Projects
  module SetsUpdatedBy
    extend ActiveSupport::Concern

    private

    def set_updated_by
      issuable_resource.updated_by = current_user
    end
  end
end
