import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stroll-tracker"
export default class extends Controller {
  static targets = ["sentinel"];

  connect() {
    const articleStatus = this.element.dataset.status;
    if (articleStatus !== "unread") return;

    this.observer = new IntersectionObserver(this.handleIntersect.bind(this), {
      root: null, // Observe in the viewport
      threshold: 1.0, // Trigger when fully visible
    });

    if (this.sentinelTarget) this.observer.observe(this.sentinelTarget);
  }

  disconnect() {
    if (this.observer) this.observer.disconnect();
  }

  handleIntersect(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) this.markAsRead()
    });
  }

  async markAsRead() {
    try {
      if ( this.element.dataset.status == 'read' ) return;

      const articleId = this.element.id.split('_').pop();

      const response = await fetch(`/articles/${articleId}/toggle_status`, {
        method: 'PATCH',
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        },
      });

      if (!response.ok) return;

      this.element.dataset.status = 'read';
      document.getElementById(`status_text_article_${articleId}`).innerText = 'Read'
    } catch (error) {
      console.error("Error marking article as read:", error);
    }
  }
}
