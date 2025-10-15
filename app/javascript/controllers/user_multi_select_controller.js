import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "dropdown", "options", "selectedContainer", "hiddenInputs"]
  static values = { url: String, selected: String, fieldName: String }

  connect() {
    this.selectedUsers = new Map()
    this.searchTimeout = null
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.boundHandleClickOutside)
    
    this.initializeSelectedUsers()
  }

  disconnect() {
    document.removeEventListener('click', this.boundHandleClickOutside)
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }
  }

  async initializeSelectedUsers() {
    if (this.selectedValue) {
      const selectedIds = this.selectedValue.split(',').filter(id => id.trim() !== '')
      
      if (selectedIds.length > 0) {
        try {
          const response = await fetch(`${this.urlValue}?ids=${selectedIds.join(',')}`)
          const users = await response.json()
          users.forEach(user => {
            this.addSelectedUser(user.id.toString(), user)
          })
        } catch (error) {
          console.error('Failed to load selected users:', error)
        }
      }
    }
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideDropdown()
    }
  }

  async search(event) {
    const query = event.target.value.trim()

    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }

    this.searchTimeout = setTimeout(async () => {
      if (query.length >= 1) {
        await this.loadUsers(query)
        this.showDropdown()
      } else {
        this.hideDropdown()
      }
    }, 300)
  }

  async loadUsers(query = '') {
    try {
      if (query.length >= 1) {
        const url = `${this.urlValue}?q=${query}`
        const response = await fetch(url)
        const users = await response.json()
        this.updateDropdown(users)
      } else {
        this.updateDropdown([])
      }
    } catch (error) {
      console.error('Failed to load users:', error)
      this.optionsTarget.innerHTML = '<div class="px-3 py-2 text-red-500 text-sm">Error loading users</div>'
    }
  }

  updateDropdown(users) {
    this.optionsTarget.innerHTML = ''
    
    if (users.length === 0) {
      this.optionsTarget.innerHTML = '<div class="px-3 py-2 text-slate-500 text-sm">Type to search users...</div>'
      return
    }

    users.forEach(user => {
      const option = this.createOption(user)
      this.optionsTarget.appendChild(option)
    })
  }

  createOption(user) {
    const isSelected = this.selectedUsers.has(user.id.toString())
    
    const option = document.createElement('div')
    option.className = `px-3 py-2 hover:bg-slate-50 cursor-pointer border-b border-slate-100 last:border-b-0 flex items-center justify-between ${isSelected ? 'bg-blue-50' : ''}`
    option.setAttribute('data-action', 'click->user-multi-select#selectUser')
    option.setAttribute('data-user-id', user.id)
    option.setAttribute('data-username', user.username)
    option.setAttribute('data-name', user.name)
    
    const userInfo = document.createElement('div')
    userInfo.className = 'flex items-center gap-2'
    
    const avatar = document.createElement('div')
    avatar.className = 'w-6 h-6 rounded-full bg-gradient-to-br from-blue-400 to-blue-500 flex items-center justify-center text-xs font-bold text-white'
    avatar.textContent = user.username.charAt(0).toUpperCase()
    
    const nameContainer = document.createElement('div')
    nameContainer.className = 'flex flex-col'
    
    const nameSpan = document.createElement('span')
    nameSpan.className = `text-sm font-medium ${isSelected ? 'text-blue-700' : 'text-slate-900'}`
    nameSpan.textContent = user.username
    
    if (user.name) {
      const fullNameSpan = document.createElement('span')
      fullNameSpan.className = 'text-xs text-slate-500'
      fullNameSpan.textContent = user.name
      nameContainer.appendChild(nameSpan)
      nameContainer.appendChild(fullNameSpan)
    } else {
      nameContainer.appendChild(nameSpan)
    }
    
    userInfo.appendChild(avatar)
    userInfo.appendChild(nameContainer)
    option.appendChild(userInfo)
    
    if (isSelected) {
      const checkmark = document.createElement('div')
      checkmark.className = 'text-blue-600 text-sm'
      checkmark.innerHTML = '✓'
      option.appendChild(checkmark)
    }
    
    return option
  }

  selectUser(event) {
    event.stopPropagation()
    
    const userId = event.currentTarget.dataset.userId
    const user = {
      id: userId,
      username: event.currentTarget.dataset.username,
      name: event.currentTarget.dataset.name
    }
    
    if (this.selectedUsers.has(userId)) {
      this.selectedUsers.delete(userId)
    } else {
      this.selectedUsers.set(userId, user)
    }
    
    this.renderSelectedUsers()
    this.updateHiddenInputs()
    
    const currentUsers = Array.from(this.optionsTarget.children).map(option => {
      if (option.dataset.userId) {
        return {
          id: option.dataset.userId,
          username: option.dataset.username,
          name: option.dataset.name
        }
      }
      return null
    }).filter(user => user !== null)
    
    this.updateDropdown(currentUsers)
  }

  addSelectedUser(userId, user) {
    if (this.selectedUsers.has(userId)) {
      return
    }

    this.selectedUsers.set(userId, user)
    this.renderSelectedUsers()
    this.updateHiddenInputs()
  }

  removeUser(event) {
    const userId = event.currentTarget.dataset.userId
    this.selectedUsers.delete(userId)
    this.renderSelectedUsers()
    this.updateHiddenInputs()
  }

  renderSelectedUsers() {
    this.selectedContainerTarget.innerHTML = ''
    
    this.selectedUsers.forEach((user, userId) => {
      const tag = document.createElement('div')
      tag.className = 'inline-flex items-center gap-2 px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm'
      
      const avatar = document.createElement('div')
      avatar.className = 'w-5 h-5 rounded-full bg-blue-500 flex items-center justify-center text-xs font-bold text-white'
      avatar.textContent = user.username.charAt(0).toUpperCase()
      
      const nameSpan = document.createElement('span')
      nameSpan.textContent = user.username
      
      const removeBtn = document.createElement('button')
      removeBtn.type = 'button'
      removeBtn.className = 'ml-1 text-blue-600 hover:text-blue-800 focus:outline-none'
      removeBtn.innerHTML = '×'
      removeBtn.setAttribute('data-action', 'click->user-multi-select#removeUser')
      removeBtn.setAttribute('data-user-id', userId)
      
      tag.appendChild(avatar)
      tag.appendChild(nameSpan)
      tag.appendChild(removeBtn)
      this.selectedContainerTarget.appendChild(tag)
    })
  }

  updateHiddenInputs() {
    // Find the closest form element
    const form = this.element.closest('form')
    if (!form) {
      console.error('No form found for user selection')
      return
    }
    
    // Remove any existing hidden inputs for this field
    const existingInputs = form.querySelectorAll(`input[name="${this.fieldNameValue}"], input[name="${this.fieldNameValue.replace('[]', '')}"]`)
    existingInputs.forEach(input => input.remove())
    
    // Add an empty array value to ensure the parameter is sent even when no users are selected
    if (this.selectedUsers.size === 0) {
      const emptyInput = document.createElement('input')
      emptyInput.type = 'hidden'
      emptyInput.name = this.fieldNameValue
      emptyInput.value = ''
      form.appendChild(emptyInput)
    }
    
    // Add hidden inputs for selected users
    this.selectedUsers.forEach((user, userId) => {
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = this.fieldNameValue
      input.value = userId
      form.appendChild(input)
    })
  }

  showDropdown() {
    this.dropdownTarget.classList.remove('hidden')
  }

  hideDropdown() {
    this.dropdownTarget.classList.add('hidden')
  }
}