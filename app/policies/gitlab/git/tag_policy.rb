# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Git
    class TagPolicy < BasePolicy
      delegate { project }

      condition(:protected_tag, scope: :subject) do
        ProtectedTag.protected?(project, @subject.name)
      end

      rule { can?(:admin_tag) & (~protected_tag | can?(:maintainer_access)) }.enable :delete_tag

      def project
        @subject.repository.container
      end
    end
  end
end
