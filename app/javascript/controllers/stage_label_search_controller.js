import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "options", "updateForm", "searchForm", "queryInput", "card", "labelIds"]
  static values = { stageId: Number, selected: String }

  searchTimeout = null

  connect() {
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.boundHandleClickOutside)
  }

  hideCard() {
    if (this.hasCardTarget) {
      this.cardTarget.classList.add('hidden')
    }
  }

  disconnect() {
    document.removeEventListener('click', this.boundHandleClickOutside)
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideDropdown()
    }
  }

  search(event) {
    const query = event.target.value.trim()

    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }

    this.searchTimeout = setTimeout(() => {
      if (query.length >= 1) {
        this.submitSearchForm(query)
      }
    }, 300)
  }

  submitSearchForm(query) {
    this.queryInputTarget.value = query
    this.searchFormTarget.requestSubmit()
  }

  selectLabel(event) {
    event.stopPropagation()
    const labelId = String(event.currentTarget.dataset.labelId)
    const currentIds = this.labelIdsTarget.value.split(',').filter(id => id.trim() !== '')
    const index = currentIds.indexOf(labelId)

    if (index > -1) {
      currentIds.splice(index, 1)
    } else {
      currentIds.push(labelId)
    }

    this.labelIdsTarget.value = currentIds.join(',')
    this.hideDropdown()
    this.updateFormAndSubmit()
  }

  updateFormAndSubmit() {
    this.updateFormTarget.requestSubmit()
  }

  hideDropdown() {
    this.dropdownTarget.classList.add('hidden')
    document.removeEventListener('click', this.boundHandleClickOutside)

    const searchInput = this.element.querySelector('input[type="text"]')
    if (searchInput) {
      searchInput.value = ''
    }
  }
}
