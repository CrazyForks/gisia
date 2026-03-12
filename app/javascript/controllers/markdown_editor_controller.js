import { Controller } from "@hotwired/stimulus"
import { wrapSelection, insertBlock } from "../markdown_toolbar"

export default class extends Controller {
  static targets = ["textarea", "preview", "hiddenField", "editTab", "previewTab"]
  static values = { initialContent: String, previewUrl: String }

  connect() {
    this.textareaTarget.value = this.initialContentValue
    this.sync()
    this.autoResize()
    const form = this.element.closest("form")
    if (form) {
      form.addEventListener("turbo:submit-end", (event) => {
        if (event.detail.success) this.clearEditor()
      })
    }
  }

  showEdit() {
    this.textareaTarget.classList.remove("hidden")
    this.previewTarget.classList.add("hidden")
    this.editTabTarget.classList.add("border-blue-500", "text-slate-700")
    this.editTabTarget.classList.remove("border-transparent", "text-slate-500")
    this.previewTabTarget.classList.add("border-transparent", "text-slate-500")
    this.previewTabTarget.classList.remove("border-blue-500", "text-slate-700")
  }

  showPreview() {
    this.textareaTarget.classList.add("hidden")
    this.previewTarget.classList.remove("hidden")
    this.editTabTarget.classList.add("border-transparent", "text-slate-500")
    this.editTabTarget.classList.remove("border-blue-500", "text-slate-700")
    this.previewTabTarget.classList.add("border-blue-500", "text-slate-700")
    this.previewTabTarget.classList.remove("border-transparent", "text-slate-500")

    fetch(this.previewUrlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: new URLSearchParams({ text: this.textareaTarget.value })
    })
      .then(r => r.text())
      .then(html => { this.previewTarget.innerHTML = html })
  }

  sync() {
    if (this.hasHiddenFieldTarget) {
      this.hiddenFieldTarget.value = this.textareaTarget.value
    }
  }

  autoResize() {
    const ta = this.textareaTarget
    ta.style.height = "auto"
    ta.style.height = ta.scrollHeight + "px"
  }

  clearEditor() {
    this.textareaTarget.value = ""
    this.sync()
    this.autoResize()
    this.showEdit()
  }

  bold() { wrapSelection(this.textareaTarget, "**", "**") }
  italic() { wrapSelection(this.textareaTarget, "*", "*") }
  strikethrough() { wrapSelection(this.textareaTarget, "~~", "~~") }
  insertCode() {
    const ta = this.textareaTarget
    const start = ta.selectionStart
    const end = ta.selectionEnd
    const selected = ta.value.substring(start, end)
    const atLineStart = start === 0 || ta.value[start - 1] === '\n'
    const leading = atLineStart ? '' : '\n'
    if (selected) {
      ta.setRangeText(`${leading}\`\`\`\n${selected}\n\`\`\``, start, end, 'end')
    } else {
      ta.setRangeText(`${leading}\`\`\`\n\n\`\`\``, start, end, 'end')
      const cursor = start + leading.length + 4
      ta.setSelectionRange(cursor, cursor)
    }
    ta.dispatchEvent(new Event('input'))
    ta.focus()
  }
  insertQuote() { insertBlock(this.textareaTarget, "> ", { cursorAfterText: true }) }

  insertLink() {
    const ta = this.textareaTarget
    const start = ta.selectionStart
    const end = ta.selectionEnd
    const selected = ta.value.substring(start, end)
    if (selected) {
      ta.setRangeText(`[${selected}](url)`, start, end, 'end')
      ta.setSelectionRange(start + selected.length + 3, start + selected.length + 6)
    } else {
      ta.setRangeText("[](url)", start, end, 'end')
      ta.setSelectionRange(start + 1, start + 1)
    }
    ta.dispatchEvent(new Event('input'))
    ta.focus()
  }

  insertUnorderedList() { insertBlock(this.textareaTarget, "- ", { cursorAfterText: true }) }
  insertOrderedList() { insertBlock(this.textareaTarget, "1. ", { cursorAfterText: true }) }
  insertTable() {
    insertBlock(this.textareaTarget, "|  |  |  |\n| --- | --- | --- |\n|  |  |  |", { beforeEmpty: true, trailingNewlines: 2 })
  }
  insertHr() { insertBlock(this.textareaTarget, "---") }
}
