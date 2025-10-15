# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Git
    class ChangedPath
      attr_reader :status, :path, :old_mode, :new_mode, :new_blob_id, :old_blob_id, :old_path

      def initialize(status:, path:, old_mode:, new_mode:, new_blob_id: nil, old_blob_id: nil, old_path: nil)
        @status = status
        @path = path
        @old_mode = old_mode
        @new_mode = new_mode
        @old_blob_id = old_blob_id
        @new_blob_id = new_blob_id
        @old_path = old_path.presence || @path
      end

      def new_file?
        status == :ADDED
      end

      def deleted_file?
        status == :DELETED
      end

      def renamed_file?
        status == :RENAMED
      end

      def modified_file?
        status == :MODIFIED
      end

      def submodule_change?
        # The file mode 160000 represents a "Gitlink" or a git submodule.
        # The first two digits can be used to distinguish it from regular files.
        #
        # 160000 -> 16 -> gitlink
        # 100644 -> 10 -> regular file

        [old_mode, new_mode].any? { |mode| mode.starts_with?('16') }
      end
    end
  end
end
