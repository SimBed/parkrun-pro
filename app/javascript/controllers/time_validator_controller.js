import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="time-validator"
export default class extends Controller {
  static targets = ["input", "error", "button"]
  connect() {
    this.enableButtonCheck()
  }

  validate() {
    this.enableButtonCheck()
  }

  enableButtonCheck() {
    const value = this.inputTarget.value.trim()
    const regex = /^(\d{1,2}:[0-5]\d|\d{1,2}:[0-5]\d:[0-5]\d)$/
    const valid = value === "" || regex.test(value)
    this.buttonTarget.disabled = !valid

    if (!valid) {
      this.errorTarget.textContent = "Confirm format is mm:ss or h:mm:ss"
      this.errorTarget.classList.remove("d-none")
    } else {
      this.errorTarget.classList.add("d-none")
    }
  }

  // validate(event) {
  //   const value = this.inputTarget.value.trim()

  //   // Accept mm:ss or h:mm:ss or empty (to allow clearing the filter)
  //   const regex = /^(\d{1,2}:[0-5]\d|\d{1,2}:[0-5]\d:[0-5]\d)$/
  //   const valid = value === "" || regex.test(value)
  //   this.buttonTarget.disabled = !valid

  //   if (!valid) {
  //     event.preventDefault()
  //     this.errorTarget.textContent = "Invalid format. Use mm:ss or h:mm:ss"
  //     this.errorTarget.classList.remove("d-none")
  //   } else {
  //     this.errorTarget.classList.add("d-none")
  //   }
  // }
}
