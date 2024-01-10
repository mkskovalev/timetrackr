import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "start", "end" ]

  addFieldCurrentTime() {
    this.startTarget.value = new Date().toISOString();
  }

  setEndTime(event) {
    this.endTarget.value = new Date().toISOString();
  }
}