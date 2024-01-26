import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.application.dropdownControllers = (this.application.dropdownControllers || []).concat(this)
    document.addEventListener("click", this.close.bind(this))
  }
  
  toggleMenu(event) {
    this.closeAllMenus()
    this.menuTarget.classList.toggle("hidden")
    this.positionMenu(event.currentTarget)
  }  

  positionMenu(button) {
    const buttonRect = button.getBoundingClientRect();
    const menuHeight = this.menuTarget.offsetHeight;
    const table = document.getElementById("periods_list");
    const tableRect = table.getBoundingClientRect();
    const spaceBelow = tableRect.bottom - buttonRect.bottom;
  
    if (spaceBelow < menuHeight) {
      this.menuTarget.style.bottom = `${buttonRect.height + 6}px`;
      this.menuTarget.style.top = "auto";
    } else {
      this.menuTarget.style.top = `${buttonRect.height + 6}px`;
      this.menuTarget.style.bottom = "auto";
    }
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
