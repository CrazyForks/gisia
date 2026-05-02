import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "hiddenInput", "options"]
  static values = { branches: Array, tags: Array, selected: String }

  connect() {
    this.filtered = { branches: this.branchesValue, tags: this.tagsValue }
    this.highlighted = -1
    this.allItems = []
    this.boundClickOutside = this.clickOutside.bind(this)
    document.addEventListener("click", this.boundClickOutside)
    if (this.selectedValue) {
      const found = [...this.branchesValue, ...this.tagsValue].find(i => i.ref === this.selectedValue)
      this.inputTarget.value = found ? found.label : this.selectedValue
      this.hiddenInputTarget.value = this.selectedValue
    }
  }

  disconnect() {
    document.removeEventListener("click", this.boundClickOutside)
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  open() {
    this.filtered = { branches: this.branchesValue, tags: this.tagsValue }
    this.highlighted = -1
    this.render()
    this.dropdownTarget.classList.remove("hidden")
  }

  close() {
    this.dropdownTarget.classList.add("hidden")
  }

  search(event) {
    const q = event.target.value.toLowerCase()
    this.filtered = {
      branches: this.branchesValue.filter(i => i.label.toLowerCase().includes(q)),
      tags: this.tagsValue.filter(i => i.label.toLowerCase().includes(q))
    }
    this.highlighted = -1
    this.render()
    this.dropdownTarget.classList.remove("hidden")
  }

  render() {
    const container = this.optionsTarget
    container.innerHTML = ""
    this.allItems = []

    const addGroup = (label, items) => {
      if (items.length === 0) return
      const header = document.createElement("div")
      header.className = "ref-dropdown-group-header"
      header.textContent = label
      container.appendChild(header)
      items.forEach(item => {
        const el = document.createElement("div")
        el.className = "ref-dropdown-option"
        if (item.ref === this.selectedValue) el.classList.add("ref-dropdown-option-selected")
        el.dataset.action = "click->pipeline-ref-select#select"
        el.dataset.ref = item.ref
        el.dataset.label = item.label
        el.textContent = item.label
        container.appendChild(el)
        this.allItems.push(el)
      })
    }

    addGroup("Branches", this.filtered.branches)
    addGroup("Tags", this.filtered.tags)

    if (this.allItems.length === 0) {
      const empty = document.createElement("div")
      empty.className = "ref-dropdown-empty"
      empty.textContent = "No results found"
      container.appendChild(empty)
    }
  }

  select(event) {
    const { ref, label } = event.currentTarget.dataset
    this.selectedValue = ref
    this.inputTarget.value = label
    this.hiddenInputTarget.value = ref
    this.close()
  }

  keydown(event) {
    if (this.dropdownTarget.classList.contains("hidden")) return
    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.highlighted = Math.min(this.highlighted + 1, this.allItems.length - 1)
      this.updateHighlight()
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.highlighted = Math.max(this.highlighted - 1, 0)
      this.updateHighlight()
    } else if (event.key === "Enter") {
      event.preventDefault()
      if (this.highlighted >= 0 && this.allItems[this.highlighted]) {
        this.allItems[this.highlighted].click()
      }
    } else if (event.key === "Escape") {
      this.close()
    }
  }

  updateHighlight() {
    this.allItems.forEach((el, i) => {
      if (i === this.highlighted) {
        el.classList.add("ref-dropdown-option-highlighted")
        el.scrollIntoView({ block: "nearest" })
      } else {
        el.classList.remove("ref-dropdown-option-highlighted")
      }
    })
  }
}
