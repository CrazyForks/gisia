import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileButton", "diffContainer"]
  static values = { selectedFileIndex: { type: Number, default: 0 } }

  connect() {
    this.showFile(this.selectedFileIndexValue)
    const activeButton = this.fileButtonTargets[this.selectedFileIndexValue]
    if (activeButton) this.updateActiveButton(activeButton)
  }

  selectFile(event) {
    const fileIndex = parseInt(event.currentTarget.dataset.fileIndex)
    this.showFile(fileIndex)
    this.updateActiveButton(event.currentTarget)
    history.pushState({}, '', event.currentTarget.dataset.url)
  }

  showFile(index) {
    this.diffContainerTargets.forEach((container) => {
      const containerIndex = parseInt(container.dataset.fileIndex)
      if (containerIndex === index) {
        container.classList.remove("hidden")
      } else {
        container.classList.add("hidden")
      }
    })
  }

  updateActiveButton(selectedButton) {
    this.fileButtonTargets.forEach(button => {
      button.classList.remove("bg-blue-50", "border-blue-200")
      button.classList.add("hover:bg-gray-50", "border-gray-100")
    })

    selectedButton.classList.remove("hover:bg-gray-50", "border-gray-100")
    selectedButton.classList.add("bg-blue-50", "border-blue-200")
  }
}