import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"];

  connect() {
    const startTimeString = document.getElementById('period_start').value;
    this.startTime = new Date(startTimeString);
  
    this.updateTimer();
    this.timer = setInterval(() => {
      this.updateTimer();
    }, 1000);
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
}

