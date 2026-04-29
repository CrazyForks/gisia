# frozen_string_literal: true

module Projects
  module Settings
    class ProtectedBranchesController < ProtectedRefsController

  protected

  def protected_ref_class
    ProtectedBranch
  end

  def ref_type
    :protected_branches
  end

  def render_turbo_stream_response
    status = @protected_ref&.errors&.any? ? :unprocessable_entity : :ok
    render turbo_stream: [
      turbo_stream.replace('flash', partial: 'shared/flash'),
      turbo_stream.replace('protected_branches_content',
        partial: 'projects/settings/protected_refs/protected_branches_content',
        locals: { project: @project })
    ], status: status
  end

  def protected_ref_params
    params.require(:protected_branch).permit(
      :name, :access_level, :allow_push, :allow_force_push, :allow_merge_to
    )
  end
    end
  end
end
