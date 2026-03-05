import { Controller } from "@hotwired/stimulus"
import { $convertToMarkdownString, TRANSFORMERS } from "lexxy"

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
        form.addEventListener('turbo:submit-end', this.handleSubmitEnd.bind(this))
      }
    }
  }

  handleLexxyInitialize(event) {
    if (this.initialContentValue) {
      const html = this.convertMarkdownToHtml(this.initialContentValue)
      this.editorTarget.value = html
    }

    this.updateHiddenField()
  }

  handleLexxyChange(event) {
    this.updateHiddenField()
  }

  handleFormSubmit(event) {
    this.updateHiddenField()
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.clearEditor()
    }
  }

  clearEditor() {
    if (this.editorTarget.tagName === 'LEXXY-EDITOR') {
      this.editorTarget.value = ''
      if (this.hasHiddenFieldTarget) {
        this.hiddenFieldTarget.value = ''
      }
    }
  }

  updateHiddenField() {
    if (this.hasHiddenFieldTarget) {
      const html = this.editorTarget.value
      if (html.includes('<table')) {
        this.hiddenFieldTarget.value = this.htmlToMarkdown(html)
      } else {
        let markdown = ''
        this.editorTarget.editor?.getEditorState().read(() => {
          markdown = $convertToMarkdownString(TRANSFORMERS)
        })
        this.hiddenFieldTarget.value = markdown
      }
    }
  }

  escapeHtml(text) {
    return text
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
  }

  sanitizeUrl(url) {
    if (/^(javascript|data|vbscript):/i.test(url.trim())) return '#'
    return url
  }

  convertMarkdownToHtml(markdown) {
    let html = this.escapeHtml(markdown)
      .replace(/^#{6}\s+(.+)$/gm, '<h6>$1</h6>')
      .replace(/^#{5}\s+(.+)$/gm, '<h5>$1</h5>')
      .replace(/^#{4}\s+(.+)$/gm, '<h4>$1</h4>')
      .replace(/^#{3}\s+(.+)$/gm, '<h3>$1</h3>')
      .replace(/^#{2}\s+(.+)$/gm, '<h2>$1</h2>')
      .replace(/^#{1}\s+(.+)$/gm, '<h1>$1</h1>')
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.+?)\*/g, '<em>$1</em>')
      .replace(/`(.+?)`/g, '<code>$1</code>')
      .replace(/```\n([\s\S]*?)\n```/g, '<pre><code>$1</code></pre>')
      .replace(/\[(.+?)\]\((.+?)\)/g, (_, text, url) => `<a href="${this.sanitizeUrl(url)}">${text}</a>`)
      .replace(/^\*\s+(.+)$/gm, '<li>$1</li>')
      .replace(/^\-\s+(.+)$/gm, '<li>$1</li>')
      .replace(/^\d+\.\s+(.+)$/gm, '<li>$1</li>')

    html = html.split('\n\n')
      .map(paragraph => {
        paragraph = paragraph.trim()
        if (!paragraph) return ''
        if (paragraph.includes('<h') || paragraph.includes('<li>') || paragraph.includes('<pre>')) {
          return paragraph
        }
        if (paragraph.startsWith('|')) {
          return this.markdownTableToHtml(paragraph)
        }
        return `<p>${paragraph}</p>`
      })
      .join('\n')

    html = html.replace(/(<li>.*<\/li>\s*)+/g, match => `<ul>${match}</ul>`)

    return html
  }

  markdownTableToHtml(tableText) {
    const rows = tableText.split('\n').filter(row => row.trim().startsWith('|'))
    const parseRow = row => row.split('|').slice(1, -1).map(cell => cell.trim())
    const isSeparator = row => parseRow(row).every(cell => /^:?-+:?$/.test(cell))

    let html = '<table>'
    let headerDone = false
    for (const row of rows) {
      if (isSeparator(row)) { headerDone = true; continue }
      const cells = parseRow(row)
      if (!headerDone) {
        html += '<tr>' + cells.map(c => `<th class="lexxy-content__table-cell--header">${c}</th>`).join('') + '</tr>'
      } else {
        html += '<tr>' + cells.map(c => `<td>${c}</td>`).join('') + '</tr>'
      }
    }
    html += '</table>'
    return html
  }

  htmlToMarkdown(html) {
    const doc = new DOMParser().parseFromString(html, 'text/html')
    const blocks = []
    for (const child of doc.body.children) {
      const block = this.blockToMarkdown(child)
      if (block) blocks.push(block)
    }
    return blocks.join('\n\n').trim()
  }

  blockToMarkdown(el) {
    const tag = el.tagName.toLowerCase()

    if (el.classList.contains('lexxy-content__table-wrapper')) {
      return this.tableToMarkdown(el.querySelector('table'))
    }

    if (tag === 'table') return this.tableToMarkdown(el)

    const headingMatch = tag.match(/^h([1-6])$/)
    if (headingMatch) return '#'.repeat(+headingMatch[1]) + ' ' + this.inlineToMarkdown(el)

    if (tag === 'ul') {
      return [...el.querySelectorAll(':scope > li')].map(li => '- ' + this.inlineToMarkdown(li)).join('\n')
    }

    if (tag === 'ol') {
      return [...el.querySelectorAll(':scope > li')].map((li, i) => `${i + 1}. ` + this.inlineToMarkdown(li)).join('\n')
    }

    if (tag === 'blockquote') return '> ' + this.inlineToMarkdown(el)

    if (tag === 'pre') {
      const code = el.querySelector('code')
      const lang = code?.className?.match(/language-(\w+)/)?.[1] || ''
      return '```' + lang + '\n' + (code?.textContent || el.textContent) + '\n```'
    }

    if (tag === 'hr') return '---'

    const text = this.inlineToMarkdown(el)
    return text || null
  }

  inlineToMarkdown(el) {
    let result = ''
    for (const node of el.childNodes) {
      if (node.nodeType === Node.TEXT_NODE) {
        result += node.textContent
      } else if (node.nodeType === Node.ELEMENT_NODE) {
        const tag = node.tagName.toLowerCase()
        const inner = this.inlineToMarkdown(node)
        if (tag === 'strong' || tag === 'b') result += `**${inner}**`
        else if (tag === 'em' || tag === 'i') result += `*${inner}*`
        else if (tag === 's') result += `~~${inner}~~`
        else if (tag === 'code') result += `\`${inner}\``
        else if (tag === 'a') result += `[${inner}](${node.getAttribute('href')})`
        else if (tag === 'br') result += '\n'
        else result += inner
      }
    }
    return result
  }

  tableToMarkdown(table) {
    if (!table) return null
    const rows = [...table.querySelectorAll('tr')]
    if (!rows.length) return null

    const cells = rows.map(row => [...row.querySelectorAll('th, td')].map(cell => this.inlineToMarkdown(cell).trim() || ' '))
    const colCount = Math.max(...cells.map(r => r.length))
    const separator = Array(colCount).fill('---')

    return [
      '| ' + cells[0].join(' | ') + ' |',
      '| ' + separator.join(' | ') + ' |',
      ...cells.slice(1).map(row => '| ' + row.join(' | ') + ' |')
    ].join('\n')
  }
}
