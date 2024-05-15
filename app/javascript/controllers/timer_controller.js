import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output", "button", "spinner", "clock"];

  connect() {
    let period_start = document.getElementById('period_start');

    if (period_start) {
      const startTimeString = period_start.value.replace(' ', 'T').replace(' ', '');
      this.startTime = new Date(startTimeString);
    
      this.updateTimer();
      this.timer = setInterval(() => {
        this.updateTimer();
      }, 1000);
    }
  }

  disconnect() {
    clearInterval(this.timer);
  }

  updateTimer() {
    const now = new Date();
    const difference = now - this.startTime;

    if (difference >= 0) {
      const hours = Math.floor(difference / 1000 / 60 / 60);
      const minutes = Math.floor(difference / 1000 / 60) % 60;
      const seconds = Math.floor(difference / 1000) % 60;

      this.outputTarget.textContent = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }
  }

  showSpinner() {
    if (this.hasClockTarget) {
      this.clockTarget.classList.add('hidden');
    }
    this.buttonTarget.classList.add('hidden');
    this.spinnerTarget.classList.remove('hidden');
    this.spinnerTarget.classList.add('flex');
  }
}

