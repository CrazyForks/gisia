import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="projects"
export default class extends Controller {
  static targets = [ "dropdown" ]

  connect() {
  }

  submit(event) {
    event.target.form.requestSubmit()
  }
}
