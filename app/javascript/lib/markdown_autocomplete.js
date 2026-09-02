const MEMBER_QUERY = /[\w\-.]*$/
const COMMAND_QUERY = /^\/([\w-]*)$/
const MAX_QUERY_LENGTH = 30
const DEBOUNCE_MS = 200

export default class MarkdownAutocomplete {
  constructor({ editor, editorArea, membersUrl, commandsUrl }) {
    this.editor = editor
    this.editorArea = editorArea
    this.membersUrl = membersUrl
    this.commandsUrl = commandsUrl
    this.composing = false
    this.dismissedAt = null
    this.activeIndex = 0
    this.items = []

    this.popup = document.createElement("div")
    this.popup.className = "hidden fixed z-30 w-80 max-h-64 overflow-y-auto bg-white border border-slate-300 rounded-md shadow-lg"
    this.popup.addEventListener("mousedown", (e) => e.preventDefault())
    this.popup.addEventListener("click", (e) => this.handleClick(e))
    document.body.appendChild(this.popup)

    this.onSelection = () => this.refresh()
    this.editor.addEventListener("selection", this.onSelection)

    this.contentEl = this.editorArea.querySelector(".TinyMDE")
    if (this.contentEl) {
      this.onKeyDown = (e) => this.handleKeyDown(e)
      this.contentEl.addEventListener("keydown", this.onKeyDown, true)
      this.contentEl.addEventListener("compositionstart", () => { this.composing = true })
      this.contentEl.addEventListener("compositionend", () => { this.composing = false })
      this.contentEl.addEventListener("blur", () => this.close())
    }
  }

  destroy() {
    this.popup.remove()
    if (this.contentEl) this.contentEl.removeEventListener("keydown", this.onKeyDown, true)
  }

  get isOpen() {
    return !this.popup.classList.contains("hidden")
  }

  refresh() {
    if (this.composing) return this.close()

    const match = this.detectTrigger()
    if (!match) return this.close()
    if (this.dismissedAt && this.dismissedAt.row === match.trigger.row && this.dismissedAt.col === match.trigger.col) return

    this.match = match
    this.schedule(match.type === "command" ? this.commandsUrl : this.membersUrl, match.query)
  }

  detectTrigger() {
    const focus = this.editor.getSelection()
    const anchor = this.editor.getSelection(true)
    if (!focus || !anchor) return null
    if (focus.row !== anchor.row || focus.col !== anchor.col) return null

    const line = this.editor.getContent().split("\n")[focus.row]
    if (line === undefined) return null

    const before = line.slice(0, focus.col)

    const command = before.match(COMMAND_QUERY)
    if (command) {
      return { type: "command", query: command[1], trigger: { row: focus.row, col: 0 }, focus }
    }

    const at = before.lastIndexOf("@")
    if (at === -1) return null
    if (at > 0 && !/\s/.test(before[at - 1])) return null

    const query = before.slice(at + 1)
    if (query.length > MAX_QUERY_LENGTH) return null
    if (!MEMBER_QUERY.test(query) || /\s/.test(query)) return null

    return { type: "member", query, trigger: { row: focus.row, col: at }, focus }
  }

  schedule(source, query) {
    if (!source) return this.close()

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.fetchItems(source, query), DEBOUNCE_MS)
  }

  async fetchItems(source, query) {
    this.controller?.abort()
    this.controller = new AbortController()

    const url = new URL(source, window.location.origin)
    url.searchParams.set("q", query)

    try {
      const response = await fetch(url, { signal: this.controller.signal, headers: { Accept: "text/html" } })
      if (!response.ok) return this.close()
      this.popup.innerHTML = await response.text()
      this.open()
    } catch (error) {
      if (error.name !== "AbortError") this.close()
    }
  }

  open() {
    this.items = Array.from(this.popup.querySelectorAll("[data-markdown-autocomplete-target='item']"))
    if (this.items.length === 0) return this.close()

    this.activeIndex = 0
    this.popup.classList.remove("hidden")
    this.position()
    this.highlight()
  }

  close() {
    this.popup.classList.add("hidden")
    this.items = []
    this.match = null
    clearTimeout(this.timeout)
  }

  position() {
    const selection = window.getSelection()
    if (!selection || selection.rangeCount === 0) return

    const caret = selection.getRangeAt(0).getBoundingClientRect()
    const fitsBelow = caret.bottom + this.popup.offsetHeight < window.innerHeight
    const left = Math.min(caret.left, window.innerWidth - this.popup.offsetWidth - 8)

    this.popup.style.left = `${Math.max(8, left)}px`
    this.popup.style.top = fitsBelow ? `${caret.bottom + 4}px` : `${caret.top - this.popup.offsetHeight - 4}px`
  }

  highlight() {
    this.items.forEach((item, index) => {
      const active = index === this.activeIndex
      item.classList.toggle("bg-blue-50", active)
      item.setAttribute("aria-selected", active)
    })
    this.items[this.activeIndex]?.scrollIntoView({ block: "nearest" })
  }

  handleKeyDown(event) {
    if (!this.isOpen) return

    switch (event.key) {
      case "ArrowDown":
        this.activeIndex = (this.activeIndex + 1) % this.items.length
        break
      case "ArrowUp":
        this.activeIndex = (this.activeIndex - 1 + this.items.length) % this.items.length
        break
      case "Enter":
      case "Tab":
        this.commit(this.items[this.activeIndex])
        event.preventDefault()
        event.stopPropagation()
        return
      case "Escape":
        this.dismissedAt = this.match?.trigger
        this.close()
        event.preventDefault()
        event.stopPropagation()
        return
      default:
        return
    }

    this.highlight()
    event.preventDefault()
    event.stopPropagation()
  }

  handleClick(event) {
    const item = event.target.closest("[data-markdown-autocomplete-target='item']")
    if (item) this.commit(item)
  }

  commit(item) {
    if (!item || !this.match) return

    const { type, trigger, focus } = this.match
    const value = item.dataset.value
    const text = type === "command" ? `/${value} ` : `@${value} `

    this.close()
    this.dismissedAt = null
    this.editor.paste(text, trigger, focus)
  }
}
