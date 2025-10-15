import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["repliesContainer", "replyButton"]

  toggle(event) {
    event.preventDefault()

    const repliesContainer = this.repliesContainerTarget

    // Check if replies are currently shown by looking for the reply form
    const isShown = repliesContainer.querySelector('.reply-form') !== null

    if (isShown) {
      // If already shown, just clear the content
      repliesContainer.innerHTML = '<div class="replies-placeholder"></div>'
    } else {
      // If not shown, submit the button's form to load replies
      const form = event.target.closest('form')
      if (form && form.requestSubmit) {
        form.requestSubmit()
      } else if (form) {
        form.submit()
      }
    }
  }
}