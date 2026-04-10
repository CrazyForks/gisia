# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

class TagsFinder < GitRefsFinder
  def execute(gitaly_pagination: false)
    tags = if gitaly_pagination && search.blank?
             repository.tags_sorted_by(sort, pagination_params)
           else
             repository.tags_sorted_by(sort)
           end

    by_search(tags).tap do |records|
      set_next_cursor(records) if gitaly_pagination
    end
  rescue ArgumentError => e
    raise Gitlab::Git::InvalidPageToken, "Invalid page token: #{page_token}" if e.message.include?('page token')

    raise
  end

  def total
    repository.tag_count
  end

  private

  def page_token
    "#{Gitlab::Git::TAG_REF_PREFIX}#{@params[:page_token]}" if params[:page_token]
  end
end
