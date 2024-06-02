import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["overlay", "panel", "content"]

  show(event) {
    event.preventDefault()
    const url = event.currentTarget.getAttribute("data-contentUrl")
    this.loadContent(url)
  }

  loadContent(url) {
    fetch(url, {
      method: "POST",
      headers: {
        "Accept": "text/html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
    .then(response => response.text())
    .then(html => {
      if (this.hasContentTarget) {
        this.contentTarget.innerHTML = html
        this.showModal()
      } else {
        console.error("Content target not found")
      }
    })
  }

  showModal() {
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("fixed")
    this.overlayTarget.classList.add("ease-out", "duration-300")
    this.overlayTarget.classList.remove("opacity-0")
    this.overlayTarget.classList.add("opacity-100")

    this.panelTarget.classList.remove("hidden")
    this.panelTarget.classList.add("inline-block")
    this.panelTarget.classList.add("ease-out", "duration-300")
    this.panelTarget.classList.remove("opacity-0", "translate-y-4", "sm:translate-y-0", "sm:scale-95")
    this.panelTarget.classList.add("opacity-100", "translate-y-0", "sm:scale-100")
  }

  hide(event) {
    this.overlayTarget.classList.add("ease-in", "duration-200")
    this.overlayTarget.classList.remove("opacity-100")
    this.overlayTarget.classList.add("opacity-0")

    this.panelTarget.classList.add("ease-in", "duration-200")
    this.panelTarget.classList.remove("opacity-100", "translate-y-0", "sm:scale-100")
    this.panelTarget.classList.add("opacity-0", "translate-y-4", "sm:translate-y-0", "sm:scale-95")

    setTimeout(() => {
      this.overlayTarget.classList.add("hidden")
      this.panelTarget.classList.add("hidden")
    }, 200) // Matches the duration-200 class
  }
}