import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { urlTemplate: String }

  navigate(event) {
    window.location.href = this.urlTemplateValue.replace('PLACEHOLDER', event.target.value)
  }
}
