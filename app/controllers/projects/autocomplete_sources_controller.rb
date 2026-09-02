# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class Projects::AutocompleteSourcesController < Projects::ApplicationController
  before_action :authorize_read_note!

  def members
    @participants = ::Projects::ParticipantsService
      .new(@project, current_user, participants_params)
      .execute(target)

    render partial: 'projects/autocomplete_sources/members', locals: { participants: @participants }
  end

  def commands
    @commands = available_commands

    render partial: 'projects/autocomplete_sources/commands', locals: { commands: @commands }
  end

  private

  def autocomplete_params
    @autocomplete_params ||= params.permit(:q, :type, :type_id)
  end

  # The ported ParticipantsService reads `params[:search]`. Gisia's autocomplete
  # endpoints take `q` on the wire, like the issue and epic pickers, so translate
  # here rather than diverging from upstream inside the service.
  def participants_params
    autocomplete_params.merge(search: autocomplete_params[:q])
  end

  def available_commands
    return [] if target.blank?

    commands = ::QuickActions::InterpretService
      .new(container: @project, current_user: current_user)
      .available_commands(target)
      .select { |command| ::Notes::QuickActionsService::SUPPORTED_COMMANDS.include?(command[:name]) }

    filter_commands_by_query(commands)
  end

  def filter_commands_by_query(commands)
    query = autocomplete_params[:q].to_s.strip.downcase
    return commands if query.blank?

    commands.select { |command| command[:name].to_s.start_with?(query) }
  end

  def target
    return @target if defined?(@target)

    @target =
      case autocomplete_params[:type]
      when 'MergeRequest'
        @project.merge_requests.find_by(iid: autocomplete_params[:type_id])
      when 'Issue', 'Epic', 'WorkItem'
        @project.work_items.find_by(iid: autocomplete_params[:type_id])
      end
  end

  def authorize_read_note!
    head :forbidden unless current_user&.can?(:read_note, @project)
  end
end

