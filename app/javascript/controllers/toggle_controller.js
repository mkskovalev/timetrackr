import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    url: String
  }

  toggleEvent(event) {
    const button = event.currentTarget;
    const checkState = event.currentTarget.getAttribute("aria-checked") === "true" ? false : true;

    fetch(this.urlValue, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content"),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ for_feed: checkState }),
    })
    .then(response => {
      if (response.ok) {
        this.toggleState(button, checkState);
      }
    })
    .catch(error => console.error("Error:", error));
  }

  toggleState(button, checkState) {
    button.setAttribute("aria-checked", checkState.toString());
    // Переключение классов для визуального отображения изменения состояния
    const indicator = button.querySelector('.indicator');
    const background = button.querySelector('.background');
    indicator.classList.toggle("translate-x-5", checkState);
    indicator.classList.toggle("translate-x-0", !checkState);
    background.classList.toggle("bg-indigo-600", checkState);
    background.classList.toggle("bg-gray-200", !checkState);
  }
}
