import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['preview']

  connect() {
    const color = this.element.querySelector('input[type="text"]').value
    if (color) {
      this.previewTarget.style.backgroundColor = color
    }
  }

  updatePreview() {
    const color = this.element.querySelector('input[type="text"]').value
    if (/^#[0-9A-F]{6}$/i.test(color)) {
      this.previewTarget.style.backgroundColor = color
    }
  }

  selectColor(event) {
    event.preventDefault()
    const color = event.target.dataset.colorValue
    const input = this.element.querySelector('input[type="text"]')
    input.value = color
    this.previewTarget.style.backgroundColor = color
  }
}
