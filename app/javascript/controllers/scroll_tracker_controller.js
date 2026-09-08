import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stroll-tracker"
export default class extends Controller {
  static targets = ["sentinel", "link"];

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
      if (this.markingAsRead) return;

      const articleId = this.element.id.split('_').pop();
      if (this.element.dataset.status == 'read' || this.statusTextIsRead(articleId)) return;

      this.markingAsRead = true;
      const response = await fetch(`/articles/${articleId}/toggle_status`, {
        method: 'PATCH',
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        },
      });
      this.markingAsRead = false;

      if (!response.ok) return;

      if (this.observer && this.hasSentinelTarget) this.observer.unobserve(this.sentinelTarget);
      this.element.dataset.status = 'read';
      document.getElementById(`status_text_article_${articleId}`).innerText = 'Read';
      const toggleBtn = document.querySelector(`#toggle_button_article_${articleId} button`);
      if (toggleBtn) toggleBtn.textContent = 'Mark as unread';
      this.linkTarget.removeAttribute('target');
      this.linkTarget.removeAttribute('rel');
    } catch (error) {
      this.markingAsRead = false;
      console.error("Error marking article as read:", error);
    }
  }

  statusTextIsRead(articleId) {
    const statusEl = document.getElementById(`status_text_article_${articleId}`);
    return statusEl && statusEl.innerText.trim() === 'Read';
  }
}
