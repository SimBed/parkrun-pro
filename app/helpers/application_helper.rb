module ApplicationHelper
  def active_tab(tab_name)
    controller_name.to_sym == tab_name ? "active" : ""
  end

  def sortable(column:, coltitle: nil, default_direction: "asc", sort_column:, sort_direction:, data_action: nil)
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
      link_to coltitle, { sort_option: column, sort_direction: direction }, { class: css_class }
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
