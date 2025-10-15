import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  preview(event) {
    const file = event.target.files[0]

    if (file) {
      const reader = new FileReader()

      reader.onload = (e) => {
        // Set the background image of the div instead of src
        this.previewTarget.style.backgroundImage = `url(${e.target.result})`
        this.previewTarget.style.backgroundSize = "cover"
        this.previewTarget.style.backgroundPosition = "center"
        this.previewTarget.innerHTML = "" // Clear the initial text
      }

      reader.readAsDataURL(file)
    } else {
      // Reset to default state
      this.previewTarget.style.backgroundImage = ""
      this.previewTarget.innerHTML = this.previewTarget.dataset.defaultText || "U"
    }
  }
}