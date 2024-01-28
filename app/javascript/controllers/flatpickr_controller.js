import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: true,
      enableSeconds: true,
      dateFormat: "Y-m-d H:i:S",
      time_24hr: true,
      disableMobile: true,
      maxDate: "today",
      onChange: this.handleDateChange.bind(this),
    });
  }

  handleDateChange(selectedDates, dateStr, instance) {
    const today = new Date();

    if (selectedDates[0].toDateString() === today.toDateString()) {
      instance.set('maxTime', today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds());
    } else {
      instance.set('maxTime', '23:59:59');
    }
  }
}
