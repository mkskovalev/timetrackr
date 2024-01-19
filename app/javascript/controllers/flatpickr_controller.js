import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: true,
      enableSeconds: true,
      dateFormat: "Y-m-d H:i:S",
      time_24hr: true,
    });
  }
}
