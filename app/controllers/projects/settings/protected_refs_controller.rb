# frozen_string_literal: true

module Projects
  module Settings
    class ProtectedRefsController < Projects::Settings::ApplicationController
  layout 'project_settings'

  before_action :set_protected_ref, only: %i[show edit update destroy]

  def create
    @protected_ref = protected_ref_class.new(protected_ref_params.merge(namespace: project.namespace))
    if @protected_ref.save
      flash.now[:notice] = "Successfully protected #{ref_type_singular} '#{@protected_ref.name}'"
    else
      flash.now[:alert] = @protected_ref.errors.full_messages.join(', ')
    end

    render_turbo_stream_response
  end

  def show
    render partial: protected_ref_row_partial,
      locals: { project: @project, protected_ref: @protected_ref }
  end

  def edit
    render partial: protected_ref_edit_row_partial,
      locals: { project: @project, protected_ref: @protected_ref }
  end

  def update
    if @protected_ref.update(protected_ref_params)
      flash.now[:notice] = "Successfully updated #{ref_type_singular} protection"
    else
      flash.now[:alert] = @protected_ref.errors.full_messages.join(', ')
    end

    render_update_row_turbo_stream_response
  end

  def destroy
    @protected_ref.destroy
    flash.now[:notice] = "Successfully removed protection from #{ref_type_singular} '#{@protected_ref.name}'"

    render_turbo_stream_response
  end

  protected

  def set_protected_ref
    @protected_ref = protected_ref_class.find(params[:id])
  end

  def render_update_row_turbo_stream_response
    partial = @protected_ref.errors.any? ? protected_ref_edit_row_partial : protected_ref_row_partial
    status = @protected_ref.errors.any? ? :unprocessable_entity : :ok
    render turbo_stream: [
      turbo_stream.replace('flash', partial: 'shared/flash'),
      turbo_stream.replace("#{ref_type_singular}_row_#{@protected_ref.id}",
        partial: partial,
        locals: { project: @project, protected_ref: @protected_ref })
    ], status: status
  end

  def protected_ref_class
    raise NotImplementedError, 'Subclasses must implement protected_ref_class'
  end

  def ref_type
    raise NotImplementedError, 'Subclasses must implement ref_type'
  end

  def ref_type_singular
    ref_type.to_s.singularize
  end

  def render_turbo_stream_response
    raise NotImplementedError, 'Subclasses must implement render_turbo_stream_response'
  end

  def protected_ref_row_partial
    raise NotImplementedError, 'Subclasses must implement protected_ref_row_partial'
  end

  def protected_ref_edit_row_partial
    raise NotImplementedError, 'Subclasses must implement protected_ref_edit_row_partial'
  end

  def protected_ref_params
    permitted_params = params.require(ref_type_singular.to_sym).permit(
      :name, :access_level, :allow_push, :allow_force_push, :allow_merge_to
    )

    permitted_params[:name] = permitted_params[:name].presence

    permitted_params
  end
    end
  end
end
