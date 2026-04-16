import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  static targets = ["menu"];
  connect() {
    document.addEventListener("keydown", this.handleEscapeKey.bind(this))
    document.addEventListener("click", this.handleOutsideClick.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleEscapeKey.bind(this))
    document.removeEventListener("click", this.handleOutsideClick.bind(this))
  }

  toggleMenu(event) {
    event.preventDefault();
    const isHidden = this.menuTarget.classList.contains("hidden");
    document.querySelectorAll("[data-dashboard-target='menu']").forEach(menu => {
      menu.classList.add("hidden");
    });
    if (isHidden) {
      this.menuTarget.classList.remove("hidden");
    }
  }

  handleEscapeKey(event) {
    if (event.key === "Escape") {
      this.menuTarget.classList.add("hidden")
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
