# frozen_string_literal: true

module DiffsHelper
  def parse_diff_file(diff_file)
    Diffs::ParseService.new(diff_file).execute
  end

  def diff_line_class(line)
    case line[:type]
    when 'addition'
      'group'
    when 'deletion'
      'group'
    when 'context'
      'group'
    when 'hunk_header'
      ''
    else
      'group'
    end
  end


  def diff_line_number(line_number)
    line_number.present? ? line_number : ''
  end

  def diff_file_id(diff_file)
    Digest::SHA1.hexdigest(diff_file.file_path)
  end

  def line_discussable?(line)
    line[:discussable] == true
  end

  # Todo, in batch
  def notes_for_line(line_code, merge_request)
    return [] unless line_code.present?

    merge_request.diff_notes.where(line_code: line_code).includes(:author).order(:created_at)
  end
end
