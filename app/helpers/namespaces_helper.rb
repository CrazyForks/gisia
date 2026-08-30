# frozen_string_literal: true

module NamespacesHelper
  def namespace_page_title(namespace, page = nil)
    [page, namespace.full_name].compact.join(' - ')
  end

  def can_access_namespace_settings?(namespace, user)
    return false unless user
    return true if user.admin?

    user.max_member_access_for_namespace(namespace) >= Accessible::MAINTAINER
  end
end
