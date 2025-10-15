import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  static targets = ["menu"];
  connect() {
    document.addEventListener("keydown", this.handleEscapeKey.bind(this));
  }

   disconnect() {
    document.removeEventListener("keydown", this.handleEscapeKey.bind(this));
  }

  toggleMenu(event) {
    event.preventDefault();
    this.menuTarget.classList.toggle("hidden");
  }

  handleEscapeKey(event) {
    if (event.key === "Escape") {
     if (!this.menuTarget.classList.contains("hidden")) {
        this.menuTarget.classList.add("hidden");
      }
    }
  }
}
