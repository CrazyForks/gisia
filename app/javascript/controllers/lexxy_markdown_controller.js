import { Controller } from "@hotwired/stimulus"
import { $convertToMarkdownString } from "lexxy"

export default class extends Controller {
  static targets = ["editor", "hiddenField"]
  static values = {
    initialContent: String
  }

  connect() {
    if (this.editorTarget.tagName === 'LEXXY-EDITOR') {
      this.editorTarget.addEventListener('lexxy:initialize', this.handleLexxyInitialize.bind(this))
      this.editorTarget.addEventListener('lexxy:change', this.handleLexxyChange.bind(this))

      const form = this.editorTarget.closest('form')
      if (form) {
        form.addEventListener('submit', this.handleFormSubmit.bind(this))
      }
    }
  }

  handleLexxyInitialize(event) {
    // If we have initial markdown content, convert it to HTML for the editor
    if (this.initialContentValue) {
      const html = this.convertMarkdownToHtml(this.initialContentValue)
      this.editorTarget.value = html
    }

    // Convert initial content to markdown for the hidden field
    this.updateHiddenField()
  }

  handleLexxyChange(event) {
    this.updateHiddenField()
  }

  handleFormSubmit(event) {
    this.updateHiddenField()
  }

  updateHiddenField() {
    if (this.hasHiddenFieldTarget) {
      if (this.editorTarget.getMarkdown) {
        this.hiddenFieldTarget.value = this.editorTarget.getMarkdown()
      } else {
        const htmlContent = this.editorTarget.value
        const markdown = this.convertHtmlToMarkdown(htmlContent)
        this.hiddenFieldTarget.value = markdown
      }
    }
  }

  convertMarkdownToHtml(markdown) {
    // Simple markdown to HTML converter for common elements
    let html = markdown
      // Headers
      .replace(/^#{6}\s+(.+)$/gm, '<h6>$1</h6>')
      .replace(/^#{5}\s+(.+)$/gm, '<h5>$1</h5>')
      .replace(/^#{4}\s+(.+)$/gm, '<h4>$1</h4>')
      .replace(/^#{3}\s+(.+)$/gm, '<h3>$1</h3>')
      .replace(/^#{2}\s+(.+)$/gm, '<h2>$1</h2>')
      .replace(/^#{1}\s+(.+)$/gm, '<h1>$1</h1>')

      // Bold and italic
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.+?)\*/g, '<em>$1</em>')

      // Inline code
      .replace(/`(.+?)`/g, '<code>$1</code>')

      // Code blocks
      .replace(/```\n([\s\S]*?)\n```/g, '<pre><code>$1</code></pre>')

      // Links
      .replace(/\[(.+?)\]\((.+?)\)/g, '<a href="$2">$1</a>')

      // Lists
      .replace(/^\*\s+(.+)$/gm, '<li>$1</li>')
      .replace(/^\-\s+(.+)$/gm, '<li>$1</li>')
      .replace(/^\d+\.\s+(.+)$/gm, '<li>$1</li>')

      // Paragraphs (simple approach)
      .split('\n\n')
      .map(paragraph => {
        paragraph = paragraph.trim()
        if (!paragraph) return ''
        if (paragraph.includes('<h') || paragraph.includes('<li>') || paragraph.includes('<pre>')) {
          return paragraph
        }
        return `<p>${paragraph}</p>`
      })
      .join('\n')

    // Wrap consecutive <li> elements in <ul>
    html = html.replace(/(<li>.*<\/li>\s*)+/g, match => `<ul>${match}</ul>`)

    return html
  }

  convertHtmlToMarkdown(html) {
    return $convertToMarkdownString(html)
  }

  // Handle form submission to ensure markdown is submitted
  handleFormSubmit(event) {
    this.handleLexxyChange() // Ensure latest conversion
  }
}
