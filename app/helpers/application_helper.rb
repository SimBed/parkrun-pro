module ApplicationHelper
  def sortable(column:, coltitle: nil, default_direction: "asc", sort_column:, sort_direction:)
    coltitle ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : "notcurrent"
    # if column == sort_column && sort_direction == default_direction
    #   direction = opp_direction(sort_direction)
    # end
    direction = opp_direction(sort_direction)
    link_to coltitle, { sort_option: column, sort_direction: direction }, { class: css_class }
  end

  def opp_direction(direction)
    return "desc" if direction == "asc"

    "asc"
  end

  def date_format(dates)
    dates.map { |date| date.strftime("%d %b %Y") }
  end
end
