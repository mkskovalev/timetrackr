import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "start", "end" ]

  connect() {
    this.addFieldCurrentTime()
  }

  addFieldCurrentTime() {
    this.startTarget.value = new Date().toISOString();
  }

  setTime(event) {
    this.endTarget.value = new Date().toISOString();
  }
}