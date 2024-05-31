import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const today = new Date();
    let defaultDate = this.element.value || new Date();
    if (typeof defaultDate === 'object') {
      defaultDate = this.formatDate(defaultDate);
    }
    
    flatpickr(this.element, {
      enableTime: true,
      enableSeconds: true,
      dateFormat: "Y-m-d H:i:S",
      time_24hr: true,
      disableMobile: true,
      maxDate: today,
      defaultDate: defaultDate,
    });
  }

  formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  handleDateChange(selectedDates, dateStr, instance) {
    const today = new Date();

    if (selectedDates.length > 0 && selectedDates[0].toDateString() === today.toDateString()) {
      instance.set('maxTime', today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds());
    } else {
      instance.set('maxTime', '23:59:59');
    }
  }
}
