import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 500 } }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  input() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.timeout = setTimeout(() => {
      this.element.form.requestSubmit()
    }, this.delayValue)
  }

  keypress(event) {
    if (event.key === 'Enter') {
      event.preventDefault()
      if (this.timeout) {
        clearTimeout(this.timeout)
      }
      this.element.form.requestSubmit()
    }
  }
}