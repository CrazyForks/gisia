# frozen_string_literal: true

json.id @job.id
json.name @job.name
json.stage @job.stage
json.project_id @job.project_id
json.project_name @job.project_name
json.time_in_queue_seconds @job.time_in_queue_seconds
json.project_jobs_running_on_instance_runners_count @job.project_jobs_running_on_instance_runners_count

