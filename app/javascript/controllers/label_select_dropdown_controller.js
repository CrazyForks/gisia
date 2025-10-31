import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "options", "form", "searchForm", "queryInput", "selectedLabels", "checkbox"]
  static values = { url: String, resourceId: String, resourceType: String, selected: String }

  connect() {
    this.selectedLabels = new Set()
    this.searchTimeout = null
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)

    this.loadSelectedLabels()
  }

  loadSelectedLabels() {
    if (!this.selectedLabels) {
      this.selectedLabels = new Set()
    }

    this.selectedLabels.clear()

    if (this.selectedValue) {
      const selectedIds = this.selectedValue.split(',').filter(id => id.trim() !== '')
      selectedIds.forEach(id => this.selectedLabels.add(id))
    }
  }

  selectedValueChanged() {
    this.loadSelectedLabels()
    this.syncSelectedLabels()
  }

  syncSelectedLabels() {
    if (!this.selectedLabels) return

    const selectedIds = Array.from(this.selectedLabels)

    this.selectedLabelsTargets.forEach(target => {
      target.dataset.selectedIds = selectedIds.join(',')

      target.dispatchEvent(new CustomEvent('selectedLabelsChanged', {
        detail: { selectedIds }
      }))
    })

    this.updateCheckboxStates()

    const searchInput = this.element.querySelector('input[type="text"]')
    if (searchInput && searchInput.value.trim()) {
      this.submitSearchForm(searchInput.value.trim())
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

  toggleDropdown() {
    if (this.dropdownTarget.classList.contains('hidden')) {
      this.showDropdown()
      document.addEventListener('click', this.boundHandleClickOutside)
    } else {
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

    const selectedIdsInput = this.searchFormTarget.querySelector('input[name="selected_ids"]')
    if (selectedIdsInput && this.selectedLabels) {
      selectedIdsInput.value = Array.from(this.selectedLabels).join(',')
    }

    this.searchFormTarget.requestSubmit()
  }

  selectLabel(event) {
    event.stopPropagation()

    const labelId = event.currentTarget.dataset.labelId

    if (this.selectedLabels.has(labelId)) {
      this.selectedLabels.delete(labelId)
    } else {
      this.selectedLabels.add(labelId)
    }

    this.syncSelectedLabels()
    this.updateFormAndSubmit()
  }

  updateCheckboxStates() {
    this.checkboxTargets.forEach(checkbox => {
      const labelId = checkbox.dataset.labelId
      checkbox.checked = this.selectedLabels.has(labelId)
    })
  }

  updateFormAndSubmit() {
    const labelIds = Array.from(this.selectedLabels)
    const form = this.formTarget
    const fieldName = `${this.resourceTypeValue}[label_ids][]`

    const existingInputs = form.querySelectorAll(`input[name="${fieldName}"]`)
    existingInputs.forEach(input => input.remove())

    if (labelIds.length === 0) {
      const emptyInput = document.createElement('input')
      emptyInput.type = 'hidden'
      emptyInput.name = fieldName
      emptyInput.value = ''
      form.appendChild(emptyInput)
    } else {
      labelIds.forEach(labelId => {
        const labelInput = document.createElement('input')
        labelInput.type = 'hidden'
        labelInput.name = fieldName
        labelInput.value = labelId
        labelInput.setAttribute('data-label-id', labelId)
        form.appendChild(labelInput)
      })
    }

    form.requestSubmit()

    setTimeout(() => {
      this.selectedValue = labelIds.join(',')
    }, 100)
  }

  showDropdown() {
    this.dropdownTarget.classList.remove('hidden')
  }

  hideDropdown() {
    this.dropdownTarget.classList.add('hidden')
    document.removeEventListener('click', this.boundHandleClickOutside)

    const searchInput = this.element.querySelector('input[type="text"]')
    if (searchInput) {
      searchInput.value = ''
    }

    if (this.hasOptionsTarget) {
      const frameId = "label-dropdown-options"

      this.optionsTarget.innerHTML = ''

      const frameDiv = document.createElement('div')
      frameDiv.id = frameId

      const messageDiv = document.createElement('div')
      messageDiv.className = 'px-3 py-2 text-slate-500 text-sm'
      messageDiv.textContent = 'Type to search labels...'

      frameDiv.appendChild(messageDiv)
      this.optionsTarget.appendChild(frameDiv)
    }
  }
}
