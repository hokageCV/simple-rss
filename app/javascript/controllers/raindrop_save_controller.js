import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("click", this.handleClick.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("click", this.handleClick.bind(this))
  }

  handleClick(event) {
    const button = event.target.closest("button")
    if (!button || button.disabled) return
    event.preventDefault()

    const container = this.element.closest("[id^='save_to_raindrop_']")
    if (!container) return
    const articleId = container.id.replace("save_to_raindrop_", "")

    button.textContent = "Saved to Raindrop \u2713"
    button.classList.remove("bg-gray-200", "hover:bg-gray-300", "text-gray-700", "cursor-pointer")
    button.classList.add("text-green-800", "bg-green-200")
    button.disabled = true

    const statusEl = document.getElementById(`status_text_${articleId}`)
    if (statusEl) {
      statusEl.dataset.originalStatus = statusEl.textContent.trim()
      statusEl.textContent = "Read"
    }

    const csrfToken = document.querySelector("[name='csrf-token']")?.content
    fetch(this.element.action, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: new FormData(this.element)
    }).then(response => {
      if (response.ok) {
        response.text().then(html => Turbo.renderStreamMessage(html))
      } else {
        this.revert(button, articleId, statusEl)
      }
    }).catch(() => {
      this.revert(button, articleId, statusEl)
    })
  }

  revert(button, articleId, statusEl) {
    button.textContent = "Save to Raindrop"
    button.classList.remove("text-green-800", "bg-green-200")
    button.classList.add("bg-gray-200", "hover:bg-gray-300", "text-gray-700", "cursor-pointer")
    button.disabled = false

    if (statusEl && statusEl.dataset.originalStatus) {
      statusEl.textContent = statusEl.dataset.originalStatus
    }
  }
}
