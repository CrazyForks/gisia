# frozen_string_literal: true

class Projects::MergeRequests::LinksController < Projects::ApplicationController
  include Projects::ItemLinkFindable

  before_action :set_merge_request
  before_action :set_item_link, only: [:destroy]
  before_action :set_link_target, only: [:create]

  def create
    @item_link = ItemLink.new(source: @merge_request, target: @target, namespace: @project.namespace)
    reverse_link = ItemLink.new(source: @target, target: @merge_request, namespace: @project.namespace)

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
    reverse = ItemLink.find_by(source: @item_link.target, target: @merge_request)

    ActiveRecord::Base.transaction do
      @item_link.destroy
      reverse&.destroy
    end

    respond_to { |format| format.turbo_stream }
  end

  private

  def set_link_target
    @target = find_target(params[:reference])
    return render_link_error(_('Item not found.')) if @target.nil?
    return render_link_error(_('Cannot link an item to itself.')) if @target.id == @merge_request.id
    return render_link_error(_('Only issues can be linked to a merge request.')) unless @target.is_a?(Issue)
    render_duplicate_flash if ItemLink.exists?(source: @merge_request, target: @target)
  end

  def set_merge_request
    @merge_request = @project.merge_requests.find_by!(iid: params[:merge_request_iid])
  end

  def set_item_link
    @item_link = @merge_request.item_link_records.find(params[:id])
  end
end
