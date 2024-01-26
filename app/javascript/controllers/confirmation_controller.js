import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "menu"]

  open(event) {
    event.preventDefault();
    this.modalTarget.classList.remove("hidden");
    this.form = event.currentTarget.closest("form");
  }

  confirm() {
    this.modalTarget.classList.add("hidden");
    this.form.requestSubmit();
  }

  cancel() {
    this.modalTarget.classList.add("hidden");
  }
}
