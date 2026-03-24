import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="agegroup-filter"
export default class extends Controller {
  static targets = ["content", "icon"]

  toggle() {
    this.contentTarget.classList.toggle("d-none")
    this.iconTarget.classList.toggle("rotate-90")
  }
}
