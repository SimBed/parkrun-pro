import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="runs-summaries"
export default class extends Controller {
  static targets = ["icon", "button", "summaries"]

  connect() {
    const saved = localStorage.getItem('runs-summaries-view')
    if (saved === "closed") {
      this.summariesTarget.classList.add("d-none")
    }
  }  

  toggle() {
    const isHidden = this.summariesTarget.classList.toggle("d-none")
    localStorage.setItem('runs-summaries-view', isHidden ? "closed" : "open")
  }
}
