class RunsController < ApplicationController
  allow_unauthenticated_access

  def index
    extract_filters
    prepare_filter_options
    set_filters
    set_sort_options
    handle_filter
    handle_sort
    # handle_headings
    handle_summary_stats
    handle_pagination
    set_cancel_button
  end

  # TODO: clear agegroup filters only
  def clear_filters
    session["filters"]["runs"]["any_agegroup_of"] = nil
    # clear_session(:run_filter_any_agegroup_of)
    redirect_to runs_path
  end

  # def filter
  #   clear_session(:run_filter_date, :run_filter_venue, :run_filter_any_agegroup_of)
  #   set_session("run", :date, :venue, :any_agegroup_of)
  #   redirect_to runs_path(link_from: params[:link_from], venue: params[:venue])
  # end

  def close
    @parkrun= params[:id]
  end

  private

  def extract_filters
    if params[:filters]
      new_filters = params.require(:filters).permit(
        runs: [
          :date,
          :venue,
          { any_agegroup_of: [] }
        ]
        ).to_h # convert from ActionController::Parameters to hash. Oherwise using with_indifferent_access fails

      session[:filters] ||= {}
      session[:filters].deep_merge!(new_filters)
    end

    @filters = (session[:filters] || {}).with_indifferent_access
  end

  # def extract_filters
  #   if params[:filters]
  #     session[:filters] = params.require(:filters).permit(
  #       runs: [
  #         :date,
  #         :venue,
  #         { any_agegroup_of: [] }
  #       ]
  #       ).to_h # convert from ActionController::Parameters to hash. Oherwise using with_indifferent_access fails
  #   end

  #   @filters = (session[:filters] || {}).with_indifferent_access # convert from hash to hash with indifferent access. Otherwise dig with symbols blows up.
  # end

  def set_filters
    @date = @filters.dig(:runs, :date) || @dates&.first
    @parkrun = @filters.dig(:runs, :venue)  || "All"
    # @date = session[:run_filter_date] ||= @dates&.first
    # @parkrun = session[:run_filter_venue] ||= "All"
  end

  def set_sort_options
    @link_from = params[:link_from]
    @venue = params[:venue]
    default_sort_option = "time"
    default_sort_direction = "asc"

    # if time search, ignore any sort params and use defaults, to ensure time search always sorts by time ascending
    if params[:time_input]
      @sort_option = session[:run_sort_option] = default_sort_option
      @sort_direction = session[:run_sort_direction] = default_sort_direction
    else
      @sort_option = session[:run_sort_option] = params[:sort_option] || session[:run_sort_option] || default_sort_option
      @sort_direction = session[:run_sort_direction] = params[:sort_direction] || session[:run_sort_direction] || default_sort_direction
    end
    @next_direction = @sort_direction == "asc" ? "desc" : "asc"
  end

  def handle_filter
    @runs = Run.where(date: @date)
    @runs = @runs.where(parkrun: @parkrun) unless @parkrun == "All"
    @runs = RunQuery.new(@filters, @runs, :runs).call
  end

  def handle_sort
    @runs = @runs.send("order_by_#{@sort_option}_#{@sort_direction}")
  end

  def prepare_filter_options
    prepare_dates
    prepare_agegroups
    prepare_parkruns
  end

  def prepare_parkruns
    @parkruns = [ [ "All Venues", "All" ] ] + Run.parkruns
    # ok to show parkruns that didnt have results on the selected date. Only showing parkruns that have results on the selected date is confusing if you change filters and the parkrun selected disappears from the dropdown.
    # Better to show all parkruns that have results in the database, even if they didnt have results on the selected date.
    # @parkruns = [ [ "All Venues", "All" ] ] + @runs.distinct(:parkrun).order(:parkrun).pluck(:parkrun)
  end

  # def handle_headings
  #   # needed for chart title, which cant it seems be passed by the chart endppoint
  #   @grouping_size = @runs.size < 2000 ? 60 : 20

  #   @summary_title = "#{@parkrun + (@parkrun == 'All' ? ' Venues' : '') }, #{@date}"
  #   @summary_sub_title = if session[:run_filter_any_agegroup_of]
  #     "(#{helpers.pluralize(session[:run_filter_any_agegroup_of].length, 'age-group')} selected)"
  #   else
  #     "(All age-groups)"
  #   end
  # end

  def summary_stats_method
    # if session[:run_filter_any_agegroup_of]
    if @filters.dig(:runs, :any_agegroup_of)
      :full_query
    elsif @parkrun == "All"
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
      StoredStats.for(@date, @parkrun) || full_query_method.call
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
    @cancel_button = true if @link_from == "venue_stats"
    @cancel_button_path = close_run_path(@parkrun) if @cancel_button
  end
end
