module LexxyHelpers
  def fill_in_lexxy_editor(text, selector:)
    # Find the Lexxy editor element by CSS selector
    editor = find(selector)

    # Clear existing content and type new text
    editor.click
    editor.send_keys(:ctrl, 'a') # Select all
    editor.send_keys(text)

    # Verify the content was entered
    expect(editor).to have_content(text)
  end
end