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

  // triggererd differently small screen/large screen, hence checking in multiple places for the sort option and direction
  sort(event) {
    event.preventDefault()
    console.log("sort event triggered")
    
    const el = event.currentTarget
    console.log(el)

    const sortOption =
      el.value || // triggered by selecting an option from <select> (small screen)
      el.dataset.sortOption || // triggered by link click in heading (large screen)
      el.closest("form")?.querySelector('[name="sort_option"]')?.value // triggered by sort order button click (small screen)

    const sortDirection =
      el.dataset.sortDirection || // triggered by link click in heading (large screen)
      el.closest("form")?.dataset.sortDirection // triggered by selecting an option from <select> or sort order button click (small screen)

    const names = this.loadNames()
    this.saveSortParams(sortOption, sortDirection)
    this.fetchRecords(names)
  }

  fetchRecords(names) {
    let sortOption = this.loadSortOption()
    let sortDirection = this.loadSortDirection()
    let query = names.map(n => `names[]=${encodeURIComponent(n)}`).join("&")
    if (sortOption) {
      query += `&sort_option=${encodeURIComponent(sortOption)}`
    }
    if (sortDirection) {
      query += `&sort_direction=${encodeURIComponent(sortDirection)}`
    }
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

  loadSortOption() {
  const value = localStorage.getItem("sort_option")

  if (value === null || value === "undefined") {
    return "time"
  }

  return value
}

  loadSortDirection() {
    const value = localStorage.getItem("sort_direction")

    if (value === null || value === "undefined") {
      return "asc"
    }
    console.log(value)
      return value
  }

  saveNames(names) {
    localStorage.setItem("names", JSON.stringify(names))
  }

  saveSortParams(sortOption, sortDirection) {
    localStorage.setItem("sort_option", sortOption)
    localStorage.setItem("sort_direction", sortDirection)
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
    header.classList.add("fs-fluid-7", "fst-italic", "ps-1")
    header.textContent = 'no friends added yet'
    friendsContainer.appendChild(header)
  }
}
