# frozen_string_literal: true

class ProcessPipelineJob < ApplicationJob
  queue_as :default

  def perform(pipeline_id)
    Ci::Pipeline.find_by_id(pipeline_id).try do
      process!
    end
  end
end
