# frozen_string_literal: true

module Projects
  module Settings
    class ProtectedTagsController < ProtectedRefsController

  protected

  def protected_ref_class
    ProtectedTag
  end

  def ref_type
    :protected_tags
  end

  def render_turbo_stream_response
    render turbo_stream: turbo_stream.replace('protected_tags_content',
      partial: 'projects/settings/protected_refs/protected_tags_content',
      locals: { project: @project })
  end

  def protected_ref_params
    permitted_params = params.require(:protected_tag).permit(
      :name, :access_level
    )
    permitted_params[:allow_push] = true
    permitted_params
  end
    end
  end
end