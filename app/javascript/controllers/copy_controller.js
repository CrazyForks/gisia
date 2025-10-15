import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"]

  copy() {
    if (!this.hasInputTarget || !this.hasButtonTarget) {
      console.error("Copy controller: missing required targets")
      return
    }

    const input = this.inputTarget
    const button = this.buttonTarget

    this.copyToClipboard(input.value).then(() => {
      this.showFeedback(button)
    })
  }

  copyToClipboard(text) {
    if (navigator.clipboard && typeof navigator.clipboard.writeText === "function") {
      return navigator.clipboard.writeText(text).catch((err) => {
        console.error("Failed to copy: ", err)
      })
    } else {
      const textarea = document.createElement("textarea")
      textarea.value = text
      textarea.style.position = "fixed"
      textarea.style.opacity = "0"
      document.body.appendChild(textarea)
      textarea.focus()
      textarea.select()

      try {
        document.execCommand("copy")
      } catch (err) {
        console.error("Fallback: Unable to copy", err)
      }

      document.body.removeChild(textarea)
      return Promise.resolve()
    }
  }

  showFeedback(button) {
    const originalText = button.textContent
    button.textContent = "Copied!"

    setTimeout(() => {
      button.textContent = originalText
    }, 2000)
  }
}