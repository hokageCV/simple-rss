import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  toggle(e) {
    e.preventDefault();

    let newState = this.element.dataset.expanded === 'true' ? 'false' : 'true';
    this.element.dataset.expanded = newState;
    document.cookie = `sidebar_expanded=${newState}`;
  }
}
