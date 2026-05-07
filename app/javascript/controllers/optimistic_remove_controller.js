import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("click", this.handleClick.bind(this))
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("click", this.handleClick.bind(this))
    this.element.removeEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

  handleClick(event) {
    const form = event.target.closest("form")
    if (!form) return

    const url = new URL(form.action)
    if (url.searchParams.get("source") !== "list_view") return

    const articleEl = form.closest(".group")
    articleEl.classList.add("optimistic-removed")
  }

  handleSubmitEnd(event) {
    const form = event.detail.formSubmission?.form
    if (!form) return

    const url = new URL(form.action)
    if (url.searchParams.get("source") !== "list_view") return
    if (!event.detail.success) {
      const articleEl = form.closest(".group")
      articleEl.classList.remove("optimistic-removed")
      return
    }

    const articleEl = form.closest(".group")
    articleEl.remove()
  }
}