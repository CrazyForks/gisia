import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collapsible"
export default class extends Controller {
  static targets = ["content", "icon", "header"]
  static values = { open: { type: Boolean, default: false } }

  connect() {
    if (this.openValue) {
      this.contentTarget.classList.remove("hidden")
      this.iconTarget.style.transform = "rotate(90deg)"
      if (this.hasHeaderTarget) {
        this.headerTarget.classList.add("border-b", "border-gray-200")
      }
    } else {
      this.contentTarget.classList.add("hidden")
      this.iconTarget.style.transform = "rotate(0deg)"
      if (this.hasHeaderTarget) {
        this.headerTarget.classList.remove("border-b", "border-gray-200")
      }
    }
  }

  toggle() {
    const isHidden = this.contentTarget.classList.contains("hidden")
    
    if (isHidden) {
      // Show content
      this.contentTarget.classList.remove("hidden")
      this.iconTarget.style.transform = "rotate(90deg)"
      // Add border when open
      if (this.hasHeaderTarget) {
        this.headerTarget.classList.add("border-b", "border-gray-200")
      }
    } else {
      // Hide content
      this.contentTarget.classList.add("hidden")
      this.iconTarget.style.transform = "rotate(0deg)"
      // Remove border when closed
      if (this.hasHeaderTarget) {
        this.headerTarget.classList.remove("border-b", "border-gray-200")
      }
    }
  }
}