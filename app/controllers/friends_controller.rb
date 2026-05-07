class FriendsController < ApplicationController
  allow_unauthenticated_access
  def index
    @runs = Run.name_like(params[:names])
    set_sortable_options
    handle_sort
  end

  private

  def set_sortable_options
    set_sort_options
    @sortable_options = {
      data_action: "friends#sort",
      sort_column: @sort_option,
      sort_direction: @sort_direction
    }
  end

  def set_sort_options
    default_sort_option = "time"
    default_sort_direction = "asc"
    @sort_option = params[:sort_option] || default_sort_option
    @sort_direction = params[:sort_direction] || default_sort_direction
    @next_direction = @sort_direction == "asc" ? "desc" : "asc"
  end

  def handle_sort
    @runs = @runs.send("order_by_#{@sort_option}_#{@sort_direction}")
  end
end
