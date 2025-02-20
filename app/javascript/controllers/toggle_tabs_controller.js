import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    this.initializeState();
  }

  toggle(event) {
    const clickedButton = event.currentTarget;

    const targetId = clickedButton.getAttribute("aria-controls");
    const targetElement = document.getElementById(targetId);
    
    if (!targetElement) return;

    this.buttonTargets.forEach(button => {
      button.dataset.state = "inactive";
      document.getElementById(button.getAttribute("aria-controls"))?.classList.add("hidden");
    });

    clickedButton.dataset.state = "active";
    targetElement.classList.remove("hidden");
  }

  initializeState() {
    this.buttonTargets.forEach(button => {
      const targetId = button.getAttribute("aria-controls");
      const targetElement = document.getElementById(targetId);

      if (button.dataset.state === "active") {
        targetElement?.classList.remove("hidden");
      } else {
        targetElement?.classList.add("hidden");
      }
    });
  }
}