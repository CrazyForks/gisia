import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy() {
    const source = this.sourceTarget
    const text = source.tagName === 'INPUT' ? source.value : source.textContent

    if (navigator.clipboard) {
      navigator.clipboard.writeText(text).then(() => this.showFeedback())
    } else {
      const textarea = document.createElement('textarea')
      textarea.value = text
      textarea.style.position = 'fixed'
      textarea.style.opacity = '0'
      document.body.appendChild(textarea)
      textarea.focus()
      textarea.select()
      document.execCommand('copy')
      document.body.removeChild(textarea)
      this.showFeedback()
    }
  }

  toggle() {
    const source = this.sourceTarget
    source.type = source.type === 'password' ? 'text' : 'password'
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
