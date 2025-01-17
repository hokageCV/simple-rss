import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="sidebar"
export default class extends Controller {
  connect() {
    document.addEventListener('keydown', this.handleShortcut.bind(this))
  }

  disconnect() {
    document.removeEventListener('keydown', this.handleShortcut.bind(this))
  }

  handleShortcut(e) {
    if (e.ctrlKey && e.key === 'd') {
      e.preventDefault()
      this.toggle(e)
    }
  }

  toggle(e) {
    e.preventDefault()

    let newState = this.element.dataset.expanded === 'true' ? 'false' : 'true'
    this.element.dataset.expanded = newState
    document.cookie = `sidebar_expanded=${newState}`
  }
}
