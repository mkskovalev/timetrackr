import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.menuTarget.classList.add('-translate-x-full');
  }

  toggle() {
    this.menuTarget.classList.toggle('-translate-x-full');
    this.menuTarget.classList.toggle('translate-x-0');
  }
}
