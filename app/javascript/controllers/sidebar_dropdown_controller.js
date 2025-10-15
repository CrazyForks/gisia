import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
    this.iconTarget.classList.toggle("rotate-90")
  }
}