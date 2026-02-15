# frozen_string_literal: true

class RemoveExpiredMembersJob < ApplicationJob
  queue_as :default

  def perform
    Member.expired.find_each(&:destroy)
  end
end
