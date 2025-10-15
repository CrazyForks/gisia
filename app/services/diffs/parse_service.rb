# frozen_string_literal: true

module Diffs
  class ParseService
    DIFF_LINE_TYPES = {
      addition: '+',
      deletion: '-',
      context: ' ',
      no_newline: '\\'
    }.freeze

    def initialize(diff_file)
      @diff_file = diff_file
      @raw_diff = extract_raw_diff(diff_file)
    end

    def execute
      return [] unless @raw_diff.present?

      parse_diff_lines
    end

    private

    attr_reader :diff_file, :raw_diff

    def parse_diff_lines
      lines = []
      old_line = nil
      new_line = nil

      raw_diff.lines.each do |line|
        line = line.chomp

        if hunk_header?(line)
          old_line, new_line = extract_line_numbers(line)
          lines << create_hunk_header_line(line)
          next
        end

        next if line.empty? || old_line.nil? || new_line.nil?

        diff_line = create_diff_line(line, old_line, new_line)
        lines << diff_line

        # Update line counters based on line type
        case diff_line[:type]
        when 'addition'
          new_line += 1
        when 'deletion'
          old_line += 1
        when 'context'
          old_line += 1
          new_line += 1
        end
      end

      lines
    end

    def hunk_header?(line)
      line.start_with?('@@')
    end

    def extract_line_numbers(hunk_line)
      # Parse "@@ -12,7 +12,6 @@" format
      match = hunk_line.match(/@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@/)
      return [1, 1] unless match

      [match[1].to_i, match[2].to_i]
    end

    def create_hunk_header_line(line)
      {
        type: 'hunk_header',
        content: line,
        old_line: nil,
        new_line: nil,
        line_code: nil,
        discussable: false,
        rich_text: line
      }
    end

    def create_diff_line(line, old_line, new_line)
      first_char = line[0] || ' '
      content = line[1..-1] || ''

      type = case first_char
             when DIFF_LINE_TYPES[:addition]
               'addition'
             when DIFF_LINE_TYPES[:deletion]
               'deletion'
             when DIFF_LINE_TYPES[:context]
               'context'
             when DIFF_LINE_TYPES[:no_newline]
               'no_newline'
             else
               'context'
             end

      {
        type: type,
        content: content,
        old_line: type == 'addition' ? nil : old_line,
        new_line: type == 'deletion' ? nil : new_line,
        line_code: generate_line_code(old_line, new_line, type),
        discussable: discussable?(type),
        rich_text: syntax_highlight(content, diff_file.new_path)
      }
    end

    def generate_line_code(old_line, new_line, type)
      return nil if type == 'hunk_header'

      file_hash = Digest::SHA1.hexdigest(diff_file.file_path)

      case type
      when 'addition'
        # For additions: use 0 for old_line, actual new_line
        "#{file_hash}_0_#{new_line}"
      when 'deletion'
        # For deletions: use actual old_line, 0 for new_line
        "#{file_hash}_#{old_line}_0"
      when 'context'
        # For context: use both actual line numbers
        "#{file_hash}_#{old_line}_#{new_line}"
      else
        "#{file_hash}_#{old_line}_#{new_line}"
      end
    end

    def discussable?(type)
      %w[addition deletion context].include?(type)
    end

    def syntax_highlight(content, file_path)
      # Simple HTML escaping for now - can be enhanced with proper syntax highlighting
      ERB::Util.html_escape(content)
    end

    def extract_raw_diff(diff_file)
      # Try different possible diff access patterns
      if diff_file.respond_to?(:diff) && diff_file.diff.respond_to?(:diff)
        diff_file.diff.diff
      elsif diff_file.respond_to?(:diff) && diff_file.diff.is_a?(String)
        diff_file.diff
      elsif diff_file.respond_to?(:content)
        diff_file.content
      elsif diff_file.respond_to?(:raw_diff)
        diff_file.raw_diff
      else
        Rails.logger.error "Unable to extract diff from: #{diff_file.class} - #{diff_file.methods.grep(/diff/)}"
        ""
      end
    end
  end
end