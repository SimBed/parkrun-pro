import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="agegroup-filter"
export default class extends Controller {
  static targets = ["filters", "icon", "button", "men", "women"]

  connect() {
    const saved = localStorage.getItem('run-filters-view')
    if (saved === "open") {
      this.filtersTarget.classList.remove("d-none")
      // rotating/flashing to make it more obvious that the form which takes up a lot of the view can be collapsed
      this.iconTarget.classList.add("rotate-90", "rotating")
      this.buttonTarget.classList.add("flashing")
    }
  }  

  toggle() {
    const isHidden = this.filtersTarget.classList.toggle("d-none")
    this.iconTarget.classList.toggle("rotate-90")
    this.iconTarget.classList.toggle("rotating")
    this.buttonTarget.classList.toggle("flashing")

    localStorage.setItem('run-filters-view', isHidden ? "closed" : "open")
    // this.filtersTarget.classList.toggle("d-none")
    // this.iconTarget.classList.toggle("rotate-90")
  }

  selectMen(event) {
    this.menTargets.forEach(cb => {
      cb.checked = true
      // cb.dispatchEvent(new Event("change", {bubbles: true}))
    });
    // submit once (avoids multiple submits)
    // this.menTargets[0].closest("form").requestSubmit()
    event.currentTarget.form.requestSubmit()
  }
  selectWomen(event) {
    this.womenTargets.forEach(cb => {
      cb.checked = true
      // cb.dispatchEvent(new Event("change", {bubbles: true}))
    });
    // note buggy if use event.target as this refers to the the exact clicked element (i, span, etc.) wich dont 'have a form' 
    // rather than the containing button which does 'have a form'
    event.currentTarget.form.requestSubmit()
  }

}
