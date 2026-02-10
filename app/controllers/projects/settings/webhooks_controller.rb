module Projects
  module Settings
    class WebhooksController < Projects::ApplicationController
      include WebhooksHelper
      before_action :set_webhook, only: [:edit_form, :update, :destroy]

      def index
        @webhooks = @project.namespace.web_hooks.order(id: :desc)

        respond_to do |format|
          format.html
          format.turbo_stream { render :index }
        end
      end

      def new_form
        @webhook = @project.namespace.web_hooks.build(type: 'ProjectHook')

        respond_to do |format|
          format.html
          format.turbo_stream { render :new_form }
        end
      end

      def edit_form
        respond_to do |format|
          format.html
          format.turbo_stream { render :edit_form }
        end
      end

      def create
        @webhook = @project.namespace.web_hooks.build(webhook_params.merge(type: 'ProjectHook'))

        if @webhook.save
          @webhooks = @project.namespace.web_hooks.order(id: :desc)

          respond_to do |format|
            format.turbo_stream { render :create }
            format.html { redirect_to webhooks_path(@project), notice: 'Webhook was successfully created.' }
          end
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        if @webhook.update(webhook_params)
          respond_to do |format|
            format.turbo_stream { render :update }
            format.html { redirect_to webhooks_path(@project), notice: 'Webhook was successfully updated.' }
          end
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @webhook.destroy

        respond_to do |format|
          format.turbo_stream { render :destroy }
          format.html { redirect_to webhooks_path(@project), notice: 'Webhook was successfully deleted.' }
        end
      end

      private

      def set_webhook
        @webhook = @project.namespace.web_hooks.find(params[:id])
      end

      def webhook_params
        params.require(:project_hook).permit(:url, :name, :description, :push_events, :tag_push_events)
      end
    end
  end
end
