import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { textColors: Object }
  static targets = ["currentColor", "colorInput", "colorModal"]

  connect() {
    this.boundHandleClickOutside = this.handleClickOutside.bind(this);
  }

  toggleColorModal(event) {
    if (event) {
      event.stopPropagation();
    }
    this.colorModalTarget.classList.toggle('hidden');
    
    if (this.colorModalTarget.classList.contains('hidden')) {
      document.removeEventListener('click', this.boundHandleClickOutside);
    } else {
      document.addEventListener('click', this.boundHandleClickOutside);
    }
  }

  selectColor(event) {
    event.stopPropagation();
    const newColorClass = event.currentTarget.dataset.value;
    const newTextClass = this.textColorsValue[newColorClass];
    this.updateCurrentColor(newColorClass, newTextClass);
    this.colorInputTarget.value = newColorClass;
    this.toggleColorModal();
  }

  updateCurrentColor(newColorClass, newTextClass) {
    const classList = this.currentColorTarget.classList;
    Array.from(classList).forEach((className) => {
      if (className.startsWith('bg-')) {
        classList.remove(className);
      }
      if (className.startsWith('text-')) {
        classList.remove(className);
      }
    });
    classList.add(newColorClass, newTextClass);
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target) && !this.colorModalTarget.classList.contains('hidden')) {
      this.toggleColorModal();
    }
  }

  disconnect() {
    document.removeEventListener('click', this.boundHandleClickOutside);
  }
}
