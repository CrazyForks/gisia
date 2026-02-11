# frozen_string_literal: true

module Git
  class Tag < Base
    include Wisper::Publisher

    delegate :oldrev, :newrev, :ref, to: :change

    def push
      publish_webhook_event
    end

    private

    def change
      @change ||= OpenStruct.new(params[:change])
    end

    def publish_webhook_event
      commits = project.repository.commits_between(oldrev, newrev)
      payload = Gitlab::DataBuilder::Push.build(
        project: project,
        user: current_user,
        oldrev: oldrev,
        newrev: newrev,
        ref: ref,
        commits: commits,
        push_options: params[:push_options] || {}
      )

      broadcast(:tag_push, project, payload)
    end
  end
end
