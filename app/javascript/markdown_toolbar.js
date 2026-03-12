export function wrapSelection(textarea, before, after) {
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const selected = textarea.value.substring(start, end)

  textarea.setRangeText(before + selected + after, start, end, 'end')

  if (start === end) {
    const cursor = start + before.length
    textarea.setSelectionRange(cursor, cursor)
  }

  textarea.dispatchEvent(new Event('input'))
  textarea.focus()
}

export function insertBlock(textarea, text, { beforeEmpty = false, trailingNewlines = 0, cursorAfterText = false } = {}) {
  const pos = textarea.selectionStart
  const value = textarea.value
  const atLineStart = pos === 0 || value[pos - 1] === '\n'

  let leading = ''
  if (!atLineStart) {
    leading = beforeEmpty ? '\n\n' : '\n'
  } else if (beforeEmpty) {
    leading = '\n'
  }

  const trailing = '\n'.repeat(trailingNewlines)
  const insertion = leading + text + trailing

  textarea.setRangeText(insertion, pos, pos, 'end')

  if (cursorAfterText) {
    const cursor = pos + leading.length + text.length
    textarea.setSelectionRange(cursor, cursor)
  }

  textarea.dispatchEvent(new Event('input'))
  textarea.focus()
}
