import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "options", "hiddenInput"]
  static values = { branches: Array, selected: String }

  connect() {
    this.highlightedIndex = -1
    this.filteredBranches = this.branchesValue
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    this.boundHandleKeydown = this.keydown.bind(this)
    this.boundHandleFocusOut = this.handleFocusOut.bind(this)
    document.addEventListener('click', this.boundHandleClickOutside)
    this.element.addEventListener('keydown', this.boundHandleKeydown)
    this.element.addEventListener('focusout', this.boundHandleFocusOut)
    if (this.selectedValue) {
      this.inputTarget.value = this.selectedValue
    }
    this.renderOptions(this.branchesValue)
  }

  disconnect() {
    document.removeEventListener('click', this.boundHandleClickOutside)
    this.element.removeEventListener('keydown', this.boundHandleKeydown)
    this.element.removeEventListener('focusout', this.boundHandleFocusOut)
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideDropdown()
    }
  }

  handleFocusOut(event) {
    if (!this.element.contains(event.relatedTarget)) {
      this.hideDropdown()
    }
  }

  search(event) {
    const query = event.target.value.toLowerCase()
    this.filteredBranches = this.branchesValue.filter(b => b.toLowerCase().includes(query))
    this.highlightedIndex = -1
    this.renderOptions(this.filteredBranches)
    this.showDropdown()
  }

  keydown(event) {
    if (this.dropdownTarget.classList.contains('hidden')) return

    if (event.key === 'ArrowDown') {
      event.preventDefault()
      this.highlightedIndex = Math.min(this.highlightedIndex + 1, this.filteredBranches.length - 1)
      this.updateHighlight()
    } else if (event.key === 'ArrowUp') {
      event.preventDefault()
      this.highlightedIndex = Math.max(this.highlightedIndex - 1, 0)
      this.updateHighlight()
    } else if (event.key === 'Enter') {
      event.preventDefault()
      if (this.highlightedIndex >= 0 && this.filteredBranches[this.highlightedIndex]) {
        this.selectBranch(this.filteredBranches[this.highlightedIndex])
      }
    }
  }

  updateHighlight() {
    const items = this.optionsTarget.querySelectorAll('[data-branch]')
    items.forEach((item, index) => {
      if (index === this.highlightedIndex) {
        item.classList.add('bg-blue-100', 'text-blue-700')
        item.scrollIntoView({ block: 'nearest' })
      } else {
        item.classList.remove('bg-blue-100', 'text-blue-700')
      }
    })
  }

  renderOptions(branches) {
    this.optionsTarget.innerHTML = ''

    if (branches.length === 0) {
      const empty = document.createElement('div')
      empty.className = 'px-3 py-2 text-slate-500 text-sm'
      empty.textContent = 'No branches found'
      this.optionsTarget.appendChild(empty)
      return
    }

    branches.forEach(branch => {
      const el = document.createElement('div')
      el.className = 'px-3 py-2 hover:bg-slate-50 cursor-pointer border-b border-slate-100 last:border-b-0 text-sm text-slate-700'
      if (branch === this.selectedValue) {
        el.classList.add('bg-blue-50', 'text-blue-600', 'font-medium')
      }
      el.dataset.action = 'click->mr-branch-select#selectFromClick'
      el.dataset.branch = branch
      el.textContent = branch
      this.optionsTarget.appendChild(el)
    })
  }

  preventBlur(event) {
    event.preventDefault()
  }

  selectFromClick(event) {
    this.selectBranch(event.currentTarget.dataset.branch)
  }

  selectBranch(branch) {
    this.selectedValue = branch
    this.inputTarget.value = branch
    this.hiddenInputTarget.value = branch
    this.highlightedIndex = -1
    this.filteredBranches = this.branchesValue
    this.renderOptions(this.branchesValue)
    this.hideDropdown()
  }

  focus() {
    this.filteredBranches = this.branchesValue
    this.highlightedIndex = -1
    this.renderOptions(this.branchesValue)
    this.showDropdown()
  }


  showDropdown() {
    this.dropdownTarget.classList.remove('hidden')
  }

  hideDropdown() {
    this.dropdownTarget.classList.add('hidden')
  }
}
