module Projects
  module Destroyable
    extend ActiveSupport::Concern

    included do
      after_destroy :remove_repo
    end


    private

    def remove_repo
      run_after_commit do
        repository.remove
      end
    end
  end
end
