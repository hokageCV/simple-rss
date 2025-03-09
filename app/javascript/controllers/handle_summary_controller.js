import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { hasApiKey: Boolean };
  static targets = ["form"];

  connect() {
    this.popover = this.element.querySelector("[popover]");
  }

  handleClick(event) {
    if (this.hasApiKeyValue) {
      this.formTarget.requestSubmit()
    } else {
      event.preventDefault();
      this.showPopover();
    }
  }

  showPopover() {
    this.popover.showPopover()
    setTimeout(() => this.popover.hidePopover(), 3000);
  }
}
