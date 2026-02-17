# frozen_string_literal: true

module Ci
  module Retryable
    extend ActiveSupport::Concern

    def retry!(current_user)
      unless retryable?
        errors.add(:base, 'Job is not retryable')
        return
      end

      new_job = clone(current_user: current_user)
      new_job.enqueue! if new_job.save!
      new_job.update_older_statuses_retried!

      ProcessPipelineJob.perform_later(pipeline_id)

      new_job
    end
  end
end
