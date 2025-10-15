# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module RunnerSetupScripts
  extend ActiveSupport::Concern

  private

  def private_runner_setup_scripts
    instructions = Gitlab::Ci::RunnerInstructions.new(os: script_params[:os], arch: script_params[:arch])
    output = {
      install: instructions.install_script,
      register: instructions.register_command
    }

    if instructions.errors.any?
      render json: { errors: instructions.errors }, status: :bad_request
    else
      render json: output
    end
  end

  def script_params
    params.permit(:os, :arch)
  end
end
