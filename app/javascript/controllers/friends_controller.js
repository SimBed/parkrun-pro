import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'selectedFriends']
  connect() {
    this.updateNamesUI()

    const names = this.loadNames()
    if (names.length > 0) {
      this.fetchRecords(names)
    }
  }

  add(event) {
    event.preventDefault()
    
    const name = this.inputTarget.value.trim()
    if (!name) return
    
    let names = this.loadNames()
    
    if (names.includes(name)) return
    if (names.length >= 5) return
    
    names.push(name)
    this.saveNames(names)
    
    this.inputTarget.value = ""
    console.log(names)
    this.updateNamesUI()
    this.fetchRecords(names)
  }

   remove(event) {
    event.preventDefault()

    const name = event.params.name

    let names = this.loadNames().filter(n => n !== name)
    this.saveNames(names)

    this.updateNamesUI()
    this.fetchRecords(names)
  } 

  fetchRecords(names) {
    const query = names.map(n => `names[]=${encodeURIComponent(n)}`).join("&")

    fetch(`/friends?${query}`, {
      headers: { "Accept": "text/vnd.turbo-stream.html" }
    })  
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }

  loadNames() {
    // ['Jon Smith' , 'Mary Jones'] with some added protection for nil or bad data
    try {
      const stored = localStorage.getItem("names")
      const names = stored ? JSON.parse(stored) : []
      return Array.isArray(names) ? names : []
    } catch {
      return []
    }
  }

  saveNames(names) {
    localStorage.setItem("names", JSON.stringify(names))
  }

  updateNamesUI() {
    const names = this.loadNames()
    let friendsContainer = this.selectedFriendsTarget
    friendsContainer.innerHTML = ""
    if (names.length > 0) {
      this.renderFriends(names, friendsContainer) }
    else {
      this.renderNoFriends(friendsContainer)
    }
  }
    
  renderFriends(names, friendsContainer) {
    names.forEach(name => {
      const wrapper = document.createElement("div")
      wrapper.classList.add("input-group", "input-group-sm", "mb-1")
      
      const input = document.createElement("input")
      input.type = "text"
      input.value = name
      input.readOnly = true

      const button = document.createElement("button")
      button.classList.add("btn", "btn-primary", "btn-sm", "p-1")    
      button.setAttribute("data-action", "friends#remove")
      button.setAttribute("data-friends-name-param", name)

      const icon = document.createElement("icon")
      icon.classList.add("bi", "bi-dash-lg")

      button.appendChild(icon)
      wrapper.appendChild(input)
      wrapper.appendChild(button)
      friendsContainer.appendChild(wrapper)
    })
  }

  renderNoFriends(friendsContainer) {
    const header = document.createElement("h2")
    header.classList.add("fs-fluid-7", "fst-italic",   "ps-1")
    header.textContent = 'no friends added yet'
    friendsContainer.appendChild(header)

  }
}
