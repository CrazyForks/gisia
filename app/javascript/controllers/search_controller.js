import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  search(event) {
    // Clear any existing timeout
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    // Set a new timeout to debounce the search
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.delayValue)
  }
}