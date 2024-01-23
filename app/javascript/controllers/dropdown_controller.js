import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.application.dropdownControllers = (this.application.dropdownControllers || []).concat(this)
    document.addEventListener("click", this.close.bind(this))
  }
  
  toggleMenu() {
    this.closeAllMenus()
    this.menuTarget.classList.toggle("hidden")
  }  

  closeAllMenus() {
    this.application.dropdownControllers.forEach(controller => {
      if (controller != this) {
        controller.menuTarget.classList.add("hidden")
      }
    })
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }

  disconnect() {
    document.removeEventListener("click", this.close)
  }
}
