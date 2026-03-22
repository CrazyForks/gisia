# frozen_string_literal: true

module Groups::Authorizable
  extend ActiveSupport::Concern

  private

  def user_groups
    current_user.accessible_namespaces
  end

  def authorize_group!(ability, namespace)
    Ability.allowed?(current_user, ability, namespace)
  end
end
