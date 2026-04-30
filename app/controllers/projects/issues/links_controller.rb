# frozen_string_literal: true

class Projects::Issues::LinksController < Projects::ApplicationController
  include Projects::IssueAuthorizable
  include Projects::ItemLinkFindable

  before_action :set_issue
  before_action :authorize_update_issuable!
  before_action :set_item_link, only: [:destroy]
  before_action :set_link_target, only: [:create]

  def create
    @item_link = ItemLink.new(source: @issue, target: @target, namespace: @project.namespace)
    reverse_link = ItemLink.new(source: @target, target: @issue, namespace: @project.namespace)

    success = ActiveRecord::Base.transaction do
      @item_link.save && reverse_link.save
    end

    if success
      respond_to { |format| format.turbo_stream }
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @item_link_id = @item_link.id
    reverse = ItemLink.find_by(source: @item_link.target, target: @issue)

    ActiveRecord::Base.transaction do
      @item_link.destroy
      reverse&.destroy
    end

    respond_to { |format| format.turbo_stream }
  end

  private

  def issuable_resource
    @issue
  end

  def authorization_denied!
    head :not_found
  end

  def set_issue
    @issue = @project.namespace.work_items.where(type: 'Issue').find_by!(iid: params[:issue_iid])
  end

  def set_link_target
    @target = find_target(params[:reference])
    return render_link_error(_('Item not found.')) if @target.nil?
    return render_link_error(_('Cannot link an item to itself.')) if @target.id == @issue.id
    return render_link_error(_('Only issues and merge requests can be linked.')) unless @target.is_a?(MergeRequest) || @target.is_a?(Issue)
    render_duplicate_flash if ItemLink.exists?(source: @issue, target: @target)
  end

  def set_item_link
    @item_link = @issue.item_link_records.find(params[:id])
    @target = @item_link.target
  end
end
