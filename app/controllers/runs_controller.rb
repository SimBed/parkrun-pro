class RunsController < ApplicationController
  allow_unauthenticated_access

  def index
    extract_filters
    prepare_filter_options
    set_filters
    set_referrer
    set_sort_options
    handle_filter
    handle_sort
    handle_summary_stats
    handle_pagination
    set_cancel_button
  end

  # TODO: clear agegroup filters only
  def clear_filters
    session["filters"]["runs"]["any_agegroup_of"] = nil
    redirect_to runs_path
  end

  def close
    @venue = params[:venue]
  end

  private

  def extract_filters
    if params[:filters]
      new_filters = filter_params.to_h # convert from ActionController::Parameters to hash. Oherwise with_indifferent_access fails

      normalize_runs_filters!(new_filters)

      session[:filters] ||= {}
      session[:filters].deep_merge!(new_filters)
    end

    @filters = (session[:filters] || {}).with_indifferent_access
  end

  def set_filters
    @date = @filters.dig(:runs, :date) || @dates&.first
    @venue = @filters.dig(:runs, :venue)  || "All"
  end

  # retain if request came from a turboized venue_stats page
  def set_referrer
    @referrer = params[:referrer]
  end

  def set_sort_options
    default_sort_option = "time"
    default_sort_direction = "asc"

    # if time search, ignore any sort params (for this request) and use defaults, to ensure time search always sorts by time ascending
    if params[:time_input]
      @sort_option = default_sort_option
      @sort_direction = default_sort_direction
    else
      @sort_option = session[:run_sort_option] = params[:sort_option] || session[:run_sort_option] || default_sort_option
      @sort_direction = session[:run_sort_direction] = params[:sort_direction] || session[:run_sort_direction] || default_sort_direction
    end
    @next_direction = @sort_direction == "asc" ? "desc" : "asc"
  end

  def handle_filter
    @runs = Run.where(date: @date)
    @runs = @runs.where(venue: @venue) unless @venue == "All"
    @runs = RunQuery.new(@filters, @runs, :runs).call
  end

  def handle_sort
    @runs = @runs.send("order_by_#{@sort_option}_#{@sort_direction}")
  end

  def prepare_filter_options
    prepare_dates
    prepare_agegroups
    prepare_venues
  end

  def prepare_venues
    @venues = [ [ "All Venues", "All" ] ] + Run.venues
    # ok to show venues that didnt have results on the selected date. Only showing venues that have results on the
    # selected date is confusing if you change filters and the venue selected disappears from the dropdown.
    # Better to show all venues that have results in the database, even if they didnt have results on the selected date.
  end

  def summary_stats_method
    if @filters.dig(:runs, :any_agegroup_of)
      :full_query
    elsif @venue == "All"
      :material_view
    else
      :stored_stats
    end
  end

  def handle_summary_stats
    # Use of lambda for lazy execution (only run if needed)
    full_query_method = -> { @runs.unscope(:order).summary_stats[0] }
    @summary_stats = case summary_stats_method
    when :full_query
      full_query_method.call
    when :material_view
      SummaryStats.on(@date)[0] || full_query_method.call
    when :stored_stats
      StoredStats.for(@date, @venue) || full_query_method.call
    end
  end

  def handle_pagination
    pagy_limit = 1000
    time_input = params[:time]
    if Utility::TimeParser.correct_time_format?(time_input)
      page = Utility::PageFinder.find_page(time_input, @runs, pagy_limit)
      redirect_to runs_path(page: page, time_input:) and return
    end
    @show_pagy = true if @runs.size > pagy_limit
    @pagy, @runs = pagy(:countish, @runs, limit: pagy_limit, size: 25)
  end

  def set_cancel_button
    @cancel_button = true if @referrer == "venue_stats"
    @cancel_button_path = close_run_path(@venue) if @cancel_button
  end

  def filter_params
    params.require(:filters).permit(
      runs: [
        :date,
        :venue,
        { any_agegroup_of: [] }
      ]
    )
  end
end
