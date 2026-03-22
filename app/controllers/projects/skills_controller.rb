# frozen_string_literal: true

class Projects::SkillsController < Projects::ApplicationController
  include Gitlab::Auth::AuthFinders

  def project_skill
    content = repo_skill_content('project')
    return render plain: content, content_type: 'text/markdown', layout: false if content

    render 'project', formats: [:text], content_type: 'text/markdown', layout: false
  end

  def issues
    content = repo_skill_content('issues')
    return render plain: content, content_type: 'text/markdown', layout: false if content

    render formats: [:text], content_type: 'text/markdown', layout: false
  end

  def epics
    content = repo_skill_content('epics')
    return render plain: content, content_type: 'text/markdown', layout: false if content

    render formats: [:text], content_type: 'text/markdown', layout: false
  end

  def labels
    content = repo_skill_content('labels')
    return render plain: content, content_type: 'text/markdown', layout: false if content

    render formats: [:text], content_type: 'text/markdown', layout: false
  end

  def branches
    content = repo_skill_content('branches')
    return render plain: content, content_type: 'text/markdown', layout: false if content

    render formats: [:text], content_type: 'text/markdown', layout: false
  end

  private

  def repo_skill_content(name)
    return nil if @project.repository.empty?

    blob = @project.repository.blob_at_branch(@project.default_branch, ".gisiabot/skills/#{name}.md")
    blob&.data
  end

  def current_user
    @current_user ||= begin
      find_user_from_access_token
    rescue Gitlab::Auth::AuthenticationError
      nil
    end || super
  end

  def authenticate_unless_public!
    return if @project&.public?

    if request.headers['PRIVATE-TOKEN'].present?
      head :unauthorized unless current_user
    else
      authenticate_user!
    end
  end
end
