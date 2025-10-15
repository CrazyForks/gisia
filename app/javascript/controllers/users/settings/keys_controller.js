import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard--projects"
export default class extends Controller {
  static targets = ["menu"];

  connect() {
    document.addEventListener("keydown", this.handleEscapeKey.bind(this));
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

   disconnect() {
    document.removeEventListener("keydown", this.handleEscapeKey.bind(this));
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  toggleMenu(event) {
    event.preventDefault();
    event.stopPropagation();
    this.menuTarget.classList.toggle("hidden");
  }

  handleEscapeKey(event) {
    if (event.key === "Escape") {
     if (!this.menuTarget.classList.contains("hidden")) {
        this.menuTarget.classList.add("hidden");
      }
    }
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}

