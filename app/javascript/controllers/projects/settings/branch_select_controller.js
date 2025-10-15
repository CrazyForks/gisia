import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "customInput"]

  connect() {
    this.toggleInputs()
  }

  disconnect() {
    // Clean up when controller is disconnected
  }

  handleChange() {
    this.toggleInputs()
  }

  toggleInputs() {
    const isCustom = this.selectTarget.value === 'custom'
    
    if (isCustom) {
      this.selectTarget.style.display = 'none'
      this.customInputTarget.style.display = 'block'
      this.customInputTarget.disabled = false
      this.customInputTarget.focus()
      this.selectTarget.disabled = true
    } else {
      this.selectTarget.style.display = 'block'  
      this.customInputTarget.style.display = 'none'
      this.customInputTarget.disabled = true
      this.selectTarget.disabled = false
    }
  }
}