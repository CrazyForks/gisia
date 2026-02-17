import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy() {
    const text = this.sourceTarget.textContent
    navigator.clipboard.writeText(text).then(() => {
      this.showFeedback()
    })
  }

  showFeedback() {
    const originalBg = this.sourceTarget.classList.contains("bg-white")
    this.sourceTarget.classList.remove("bg-white")
    this.sourceTarget.classList.add("bg-green-100")

    setTimeout(() => {
      this.sourceTarget.classList.remove("bg-green-100")
      if (originalBg) this.sourceTarget.classList.add("bg-white")
    }, 1000)
  }
}
