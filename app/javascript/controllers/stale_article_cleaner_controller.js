import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener("visibilitychange", this.#onVisibilityChange)
  }

  disconnect() {
    document.removeEventListener("visibilitychange", this.#onVisibilityChange)
  }

  #onVisibilityChange = () => {
    if (document.visibilityState === "visible") {
      this.#cleanStaleArticles()
    }
  }

  #cleanStaleArticles() {
    const articleEls = this.element.querySelectorAll("[id^='article_']")
    const ids = Array.from(articleEls).map(el => el.id.replace("article_", ""))
    if (ids.length === 0) return

    fetch(`/articles/check_read_status?ids[]=${ids.join("&ids[]=")}`, {
      headers: { Accept: "application/json" }
    })
      .then(r => r.json())
      .then(data => {
        data.read_ids.forEach(id => {
          const el = document.getElementById(`article_${id}`)
          if (el) el.remove()
        })
      })
  }
}
