import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "label"]

  toggle() {
    const hidden = this.contentTarget.classList.toggle("hidden")
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = hidden ? "Compare" : "Hide"
    }
  }
}
