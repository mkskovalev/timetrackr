import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["currentTimeLine", "currentPeriod"]

  connect() {
    this.currentDate = new Date();
    this.updateCurrentTimeLine()
    this.interval = setInterval(() => {
      this.updateCurrentTimeLine()
    }, 60000) // Update every one minute
  }

  updateCurrentTimeLine() {
    const now = new Date();

    // Check if the day has changed
    if (now.getDate() !== this.currentDate.getDate() ||
      now.getMonth() !== this.currentDate.getMonth() ||
      now.getFullYear() !== this.currentDate.getFullYear()) {
      this.currentDate = now;
      this.fetchUpdateTimeline();
    }

    const startOfDay = new Date(now).setHours(0, 0, 0, 0);
    const millisecondsInDay = now - startOfDay;
    const percentOfDayPassed = (millisecondsInDay / (24 * 60 * 60 * 1000)) * 100;
    // Subtract half the line width to center
    this.currentTimeLineTarget.style.left = `calc(${percentOfDayPassed}% - 0.5px)`;

    if (this.hasCurrentPeriodTarget) {
      const periodStartPercentage = parseFloat(this.currentPeriodTarget.style.left);
      // Convert minWidth to percentage
      const minPeriodWidth = parseFloat(getComputedStyle(this.currentPeriodTarget).minWidth) / this.element.offsetWidth * 100;
      const periodWidthPercentage = Math.max(percentOfDayPassed - periodStartPercentage, minPeriodWidth);
      this.currentPeriodTarget.style.width = `${periodWidthPercentage}%`;
  
      if (periodWidthPercentage == minPeriodWidth) {
        // Adjust the left position of the current period to prevent overlap
        this.currentPeriodTarget.style.left = `calc(${percentOfDayPassed}% - ${minPeriodWidth}%)`;
      }
    }
  }

  fetchUpdateTimeline() {
    fetch('/timeline', {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
    })
    .then(response => {
      if (response.ok) {
        console.log('Timeline updated successfully');
      } else {
        throw new Error('Network response was not ok');
      }
    })
    .catch(error => {
      console.error('Error updating timeline:', error);
    });
  }

  disconnect() {
    clearInterval(this.interval)
  }
}
