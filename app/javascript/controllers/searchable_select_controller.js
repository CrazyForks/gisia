import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "hiddenInput", "option"]
  static values = { url: String, selected: String, options: Array }

  connect() {
    this.currentOptions = []
    if (this.hasOptionsValue) {
      // Static options (like status dropdown)
      this.updateDropdownFromStaticOptions(this.optionsValue)
    } else if (this.urlValue) {
      // Dynamic options (like projects dropdown)
      this.loadOptions()
    }
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.boundHandleClickOutside)
    this.searchTimeout = null
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

  async loadOptions(query = '') {
    const url = new URL(this.urlValue, window.location.origin)
    if (query) {
      url.searchParams.set('q', query)
    }

    try {
      const response = await fetch(url)
      const options = await response.json()
      this.currentOptions = options
      this.updateDropdown(options)
    } catch (error) {
      console.error('Failed to load options:', error)
    }
  }

  updateDropdown(options) {
    const optionsContainer = this.element.querySelector('[data-searchable-select-target="options"]')
    
    // Clear existing options
    optionsContainer.innerHTML = ''
    
    // Add "All" option for dynamic dropdowns
    if (this.urlValue) {
      const allOption = this.createOption('All projects', '', this.selectedValue === '')
      optionsContainer.appendChild(allOption)
    }
    
    // Add options
    options.forEach(option => {
      const optionElement = this.createOption(option, option, this.selectedValue === option)
      optionElement.classList.add('last:border-b-0')
      optionsContainer.appendChild(optionElement)
    })
  }

  updateDropdownFromStaticOptions(options) {
    const optionsContainer = this.element.querySelector('[data-searchable-select-target="options"]')
    // Hide search input for static dropdowns
    const searchContainer = this.dropdownTarget.querySelector('.p-2.border-b')
    if (searchContainer) {
      searchContainer.style.display = 'none'
    }
    
    // Clear existing options
    optionsContainer.innerHTML = ''
    
    // Add static options
    options.forEach(([text, value], index) => {
      const option = this.createOption(text, value, this.selectedValue === value)
      if (index === options.length - 1) {
        option.classList.add('last:border-b-0')
      }
      optionsContainer.appendChild(option)
    })
  }

  createOption(text, value, isSelected) {
    const option = document.createElement('div')
    option.className = 'px-3 py-2 hover:bg-gray-50 cursor-pointer border-b border-gray-100 flex items-center justify-between dropdown-option'
    option.setAttribute('data-action', 'click->searchable-select#selectOption')
    option.setAttribute('data-value', value)
    
    if (isSelected) {
      option.classList.add('bg-blue-50', 'text-blue-600', 'selected')
    }
    
    const textSpan = document.createElement('span')
    textSpan.textContent = text // Safe - uses textContent instead of innerHTML
    option.appendChild(textSpan)
    
    return option
  }

  search(event) {
    const query = event.target.value

    // Clear any existing timeout
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }

    // Set a new timeout to debounce the search
    this.searchTimeout = setTimeout(async () => {
      await this.loadOptions(query)
    }, 300) // 300ms debounce delay
  }

  selectOption(event) {
    const value = event.currentTarget.dataset.value
    const text = event.currentTarget.querySelector('span').textContent

    this.hiddenInputTarget.value = value
    this.inputTarget.value = text
    this.selectedValue = value

    // Update dropdown to show new selection before hiding
    if (this.hasOptionsValue) {
      this.updateDropdownFromStaticOptions(this.optionsValue)
    } else if (this.urlValue) {
      this.updateDropdown(this.currentOptions)
    }

    this.hideDropdown()

    // Trigger form submission
    this.element.closest('form').requestSubmit()
  }

  showDropdown() {
    this.dropdownTarget.classList.remove('hidden')
  }

  hideDropdown() {
    this.dropdownTarget.classList.add('hidden')
  }

  toggle() {
    if (this.dropdownTarget.classList.contains('hidden')) {
      this.showDropdown()
    } else {
      this.hideDropdown()
    }
  }
}