# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

module API
  module V4
    module Paginatable
      extend ActiveSupport::Concern

      private

      def paginate(collection)
        page = [params[:page].to_i, 1].max
        per_page_param = params[:per_page].to_i
        per_page = per_page_param > 0 ? [per_page_param, 100].min : 20
        result = collection.page(page).per(per_page)
        set_pagination_headers(result)
        result
      end

      def set_pagination_headers(collection)
        response.headers['X-Total'] = collection.total_count.to_s
        response.headers['X-Total-Pages'] = collection.total_pages.to_s
        response.headers['X-Page'] = collection.current_page.to_s
        response.headers['X-Per-Page'] = collection.limit_value.to_s
        response.headers['X-Next-Page'] = collection.next_page.to_s
        response.headers['X-Prev-Page'] = collection.prev_page.to_s
      end
    end
  end
end
