# frozen_string_literal: true

class TickBuildQuequeJob < ApplicationJob
  queue_as :default

  def perform(build_id)
    Ci::Build.find_by_id(build_id).try do |build|
      build.tick(build)
    end
  end
end

