# frozen_string_literal: true

module Projects::Parameterizable
  extend ActiveSupport::Concern

  private

  def available_namespaces_for_user
    current_user.accessible_namespaces
  end

  def create_params
    params.permit(:name, :path, :description, :namespace_parent_id,
      namespace_attributes: %i[visibility_level])
      .tap { |p| p[:namespace_attributes]&.merge!(creator_id: current_user.id) }
      .compact
  end
end
