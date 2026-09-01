# frozen_string_literal: true

class ClearFinishedJobsJob < ApplicationJob
  queue_as :default

  BATCH_SIZE = 500
  SLEEP_BETWEEN_BATCHES = 0.1

  def perform(finished_before: SolidQueue.clear_finished_jobs_after.ago)
    SolidQueue::Job.clear_finished_in_batches(
      batch_size: BATCH_SIZE,
      finished_before: finished_before,
      sleep_between_batches: SLEEP_BETWEEN_BATCHES
    )
  end
end
