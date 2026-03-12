module MarkdownEditorHelpers
  def fill_in_markdown_editor(text, selector:)
    find(selector).set(text)
  end
end
