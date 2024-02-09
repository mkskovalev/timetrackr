import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  change() {
    const selectedLocale = this.selectTarget.value
    const pathName = window.location.pathname.replace(/\/(en|ru)/, `/${selectedLocale}`)
    window.location.pathname = pathName
    document.cookie = `locale=${selectedLocale};path=/`
  }
}
