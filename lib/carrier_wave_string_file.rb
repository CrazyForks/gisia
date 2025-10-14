# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

class CarrierWaveStringFile < StringIO
  def original_filename
    ""
  end

  def self.new_file(file_content:, filename:, content_type: "application/octet-stream")
    {
      "tempfile" => StringIO.new(file_content),
      "filename" => filename,
      "content_type" => content_type
    }
  end
end
