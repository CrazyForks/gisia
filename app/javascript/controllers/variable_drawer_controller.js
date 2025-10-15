import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["drawer", "openButton", "content", "icon"]

  connect() {
    this.boundHandleEscape = this.handleEscape.bind(this)
    this.boundHandleOutsideClick = this.handleOutsideClick.bind(this)
    
    // Listen for successful form submissions to close drawer
    this.element.addEventListener('turbo:submit-end', (event) => {
      if (event.detail.success) {
        this.close()
      }
    })
  }

  disconnect() {
    this.removeEventListeners()
  }

  open() {
    // Remove hidden first to make it visible
    this.drawerTarget.classList.remove("hidden")
    
    // Force a reflow to ensure the element is rendered before animating
    this.drawerTarget.offsetHeight
    
    // Animate in after a short delay
    setTimeout(() => {
      this.drawerTarget.classList.remove("translate-x-full")
    }, 10)
    
    // Update button state
    if (this.hasOpenButtonTarget) {
      this.openButtonTarget.classList.add("btn-primary-active")
    }
    
    this.addEventListeners()
    
    // Focus first input after animation starts
    setTimeout(() => {
      this.focusFirstInput()
    }, 50)
  }

  close() {
    this.drawerTarget.classList.add("translate-x-full")
    
    // Update button state
    if (this.hasOpenButtonTarget) {
      this.openButtonTarget.classList.remove("btn-primary-active")
    }
    
    // Hide after animation completes
    setTimeout(() => {
      this.drawerTarget.classList.add("hidden")
    }, 300)
    
    this.removeEventListeners()
  }

  addEventListeners() {
    document.addEventListener("keydown", this.boundHandleEscape)
    document.addEventListener("click", this.boundHandleOutsideClick)
  }

  removeEventListeners() {
    document.removeEventListener("keydown", this.boundHandleEscape)
    document.removeEventListener("click", this.boundHandleOutsideClick)
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  handleOutsideClick(event) {
    if (!this.drawerTarget.contains(event.target) && 
        !this.element.contains(event.target) &&
        !this.drawerTarget.classList.contains("hidden")) {
      this.close()
    }
  }

  focusFirstInput() {
    const firstInput = this.drawerTarget.querySelector("input, select, textarea")
    if (firstInput) {
      firstInput.focus()
    }
  }

  toggleContent() {
    const isHidden = this.contentTarget.classList.contains("hidden")
    
    if (isHidden) {
      // Show content
      this.contentTarget.classList.remove("hidden")
      if (this.hasIconTarget) {
        this.iconTarget.style.transform = "rotate(90deg)"
      }
    } else {
      // Hide content
      this.contentTarget.classList.add("hidden")
      if (this.hasIconTarget) {
        this.iconTarget.style.transform = "rotate(0deg)"
      }
    }
  }
}