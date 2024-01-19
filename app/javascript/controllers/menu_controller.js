import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["internalMenu", "publicMenu"];

  connect() {
    if (this.hasInternalMenuTarget) {
      this.internalMenuTarget.classList.add('-translate-x-full');
    }
    
    if (this.hasPublicMenuTarget) {
      this.publicMenuTarget.classList.add('hidden');
    }
  }

  toggleInternalMenu() {
    this.internalMenuTarget.classList.toggle('-translate-x-full');
    this.internalMenuTarget.classList.toggle('translate-x-0');
  }

  togglePublicMenu() {
    this.publicMenuTarget.classList.toggle('hidden');
    this.publicMenuTarget.classList.toggle('block');
  }
}
