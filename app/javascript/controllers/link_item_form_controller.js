import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "createForm", "input", "searchForm", "searchQuery", "searchResults", "referenceInput"]

  connect() {
    this.searchTimeout = null
    this.boundOnSubmitEnd = this.onSubmitEnd.bind(this)
    this.createFormTarget.addEventListener('turbo:submit-end', this.boundOnSubmitEnd)
  }

  disconnect() {
    if (this.searchTimeout) clearTimeout(this.searchTimeout)
    this.createFormTarget.removeEventListener('turbo:submit-end', this.boundOnSubmitEnd)
  }

  onSubmitEnd(event) {
    this.inputTarget.value = ''
    this.referenceInputTarget.value = ''
    this.hideResults()
    if (event.detail.success) {
      this.formTarget.classList.add('hidden')
    }
  }

  toggleForm() {
    if (this.formTarget.classList.contains('hidden')) {
      this.formTarget.classList.remove('hidden')
      setTimeout(() => this.inputTarget.focus(), 0)
    } else {
      this.hideForm()
    }
  }

  hideForm() {
    this.formTarget.classList.add('hidden')
    this.inputTarget.value = ''
    this.referenceInputTarget.value = ''
    this.hideResults()
  }

  hideResults() {
    if (this.hasSearchResultsTarget) this.searchResultsTarget.classList.add('hidden')
  }

  handleClickOutside(event) {
    if (!this.formTarget.classList.contains('hidden') && !this.element.contains(event.target)) {
      this.hideForm()
    }
  }

  search(event) {
    const q = event.target.value.trim()
    if (this.searchTimeout) clearTimeout(this.searchTimeout)

    this.searchTimeout = setTimeout(() => {
      this.searchQueryTarget.value = q
      this.searchFormTarget.requestSubmit()
    }, 300)
  }

  selectItem(event) {
    this.referenceInputTarget.value = event.currentTarget.dataset.ref
    this.hideResults()
    this.createFormTarget.requestSubmit()
  }

  submitForm(event) {
    event.preventDefault()
    this.referenceInputTarget.value = this.inputTarget.value.trim()
    this.createFormTarget.requestSubmit()
  }
}
