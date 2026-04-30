module ApplicationHelper
  def active_tab(tab_name)
    controller_name.to_sym == tab_name ? "active" : ""
  end

  # the sortable method has grown in complexity:
  # data_action parameter: it needs to handle stimulus (on friends page) where localstorage gets built into the fetch request as well as direct server requests elsewhere
  # link_from parameter: on the turboized venue_stats page, we want to retain a close button after sorting
  # venue parameter: on the turboized venue_stats page, we want to retain a close button after sorting
  # def sortable(column:, coltitle: nil, default_direction: "asc", sort_column:, sort_direction:, data_action: nil, link_from: nil, venue: nil, date: nil)
  def sortable(column:, coltitle: nil, default_direction: "asc", sort_column:, sort_direction:, data_action: nil, link_from: nil, filters: nil)
    coltitle ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : "notcurrent"
    direction = opp_direction(sort_direction)
    if data_action # handle by stimulus
      link_to coltitle, "#", class: css_class,
        data: {
          action: "click->#{data_action}",
          sort_option: column,
          sort_direction: direction
        }
    else # direct request to server
      # <a class="current" href="/runs?sort_direction=desc&amp;sort_option=time">Time</a>
      # NOTE: the first hash (the options parameter) provides query params to the inferred path (eg. runs_path)
      # link_to coltitle, { sort_option: column, sort_direction: direction, link_from: link_from, filters: {runs: {venue: venue, date: date }}}, { class: css_class }
      link_to coltitle, { sort_option: column, sort_direction: direction, link_from: link_from, filters: filters }, { class: css_class }
    end
  end

  def opp_direction(direction)
    return "desc" if direction == "asc"

    "asc"
  end

  def date_format(dates)
    dates.map { |date| date.strftime("%d %b %Y") }
  end
end
