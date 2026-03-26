import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="agegroup-filter"
export default class extends Controller {
  static targets = ["filters", "icon", "men", "women"]

  connect() {
    const saved = localStorage.getItem('filters-view')
    if (saved === "open") {
      this.filtersTarget.classList.remove("d-none")
      this.iconTarget.classList.add("rotate-90")
    }
  }  

  toggle() {
    const isHidden = this.filtersTarget.classList.toggle("d-none")
    this.iconTarget.classList.toggle("rotate-90")

    localStorage.setItem('filters-view', isHidden ? "closed" : "open")
    // this.filtersTarget.classList.toggle("d-none")
    // this.iconTarget.classList.toggle("rotate-90")
  }

  selectMen(event) {
    this.menTargets.forEach(cb => {
       cb.checked = true
      cb.dispatchEvent(new Event("change", {bubbles: true}))
    });
    // submit once (avoids multiple submits)
    // this.menTargets[0].closest("form").requestSubmit()
    event.target.form.requestSubmit()
  }
  selectWomen(event) {
    this.womenTargets.forEach(cb => {
       cb.checked = true
      cb.dispatchEvent(new Event("change", {bubbles: true}))
    });
    event.target.form.requestSubmit()
  }

}
