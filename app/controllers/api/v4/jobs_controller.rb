# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025 Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module API
  module V4
    class JobsController < ::API::V4::CiBaseController
      before_action :authenticate_runner!, only: [:job_request]
      before_action :require_active_runner!, :halt_if_up_to_date!, only: [:job_request]
      before_action :authenticate_job!, :runner_heartbeat, only: %i[update trace]

      def job_request
        new_update = current_runner.ensure_runner_queue_value
        result = Ci::Runner.assign_to(current_runner, current_runner_manager, request_job_params)

        if result.valid?
          if result.build_json
            @job = result.build_presented
            render 'api/v4/jobs/request', status: :created
          else
            response.set_header('X-GitLab-Last-Update', new_update)
            head :no_content
          end
        else
          head :conflict
        end
      end

      def update
        result = @job.update_state!(state_input)

        response.set_header('Job-Status', @job.status)
        response.set_header('X-GitLab-Trace-Update-Interval', result.backoff)

        render plain: result.status.to_s, status: result.status
      end

      def trace
        unless request.headers.key?('Content-Range')
          return render plain: '400 Missing header Content-Range', status: :bad_request
        end

        result = @job.append_trace trace_input

        case result.status
        when 403
          render plain: '403 Forbidden', status: :forbidden
        when 416
          headers['Range'] = "0-#{result.stream_size}"
          render plain: '416 Range Not Satisfiable', status: 416
        else
          headers['Job-Status'] = @job.status
          headers['Range'] = "0-#{result.stream_size}"
          headers['X-GitLab-Trace-Update-Interval'] = @job.trace.update_interval.to_s

          head result.status
        end
      end

      private

      def trace_input
        ::Ci::Builds::TraceableInputBuilder.from params, request.headers, request.body
      end

      def content_range
        request.headers['Content-Range']
      end

      def debug_trace
        Gitlab::Utils.to_boolean(params[:debug_trace])
      end

      def require_active_runner!
        return if current_runner.active?

        response.set_header('X-GitLab-Last-Update', current_runner.ensure_runner_queue_value)
        head :no_content
      end

      def halt_if_up_to_date!
        return unless current_runner.runner_queue_value_latest?(request_job_params[:last_update])

        response.set_header('X-GitLab-Last-Update', request_job_params[:last_update])
        head :no_content
      end

      def request_job_params
        @request_job_params ||= params.permit(
          :system_id, :last_update,
          info: [
            :name, :version, :revision, :platform, :architecture, :executor,
            { features: {}, config: [:gpus] }
          ],
          session: %i[url certificate authorization]
        ).merge(token: token)
      end

      def state_input
        Ci::Builds::StateInputBuilder.from params
      end
    end
  end
end

