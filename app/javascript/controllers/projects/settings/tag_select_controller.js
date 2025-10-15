import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "customInput"]

  connect() {
    this.toggleInputs()
  }

  disconnect() {
    // Cleanup when controller is removed from DOM
  }

  handleChange() {
    this.toggleInputs()
  }

  toggleInputs() {
    const selectTarget = this.hasSelectTarget ? this.selectTarget : null
    const customInput = this.hasCustomInputTarget ? this.customInputTarget : null

    if (selectTarget && customInput && selectTarget.value === 'custom') {
      selectTarget.classList.add('hidden')
      selectTarget.disabled = true
      customInput.classList.remove('hidden')
      customInput.disabled = false
      customInput.focus()
    } else if (selectTarget && customInput) {
      selectTarget.classList.remove('hidden')
      selectTarget.disabled = false
      customInput.classList.add('hidden')
      customInput.disabled = true
    }
  }
}