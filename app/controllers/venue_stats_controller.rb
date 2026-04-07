class VenueStatsController < ApplicationController
  allow_unauthenticated_access

  def index
    prepare_filter_options
    set_filters
    set_sort_options
    handle_filter
    handle_summary_stats
    handle_sort
    # handle_pagination
  end

  def clear_filters
    clear_session(:venue_stats_filter_any_agegroup_of)
    redirect_to venue_stats_path
  end

  def filter
    clear_session(:venue_stats_filter_date, :venue_stats_filter_venue, :venue_stats_filter_any_agegroup_of)
    set_session("venue_stats", :date, :venue, :any_agegroup_of)
    redirect_to venue_stats_path
  end

  private

  def set_filters
    @date = session[:venue_stats_filter_date] || @dates&.first
  end

  def set_sort_options
    default_sort_option = "fastest"
    default_sort_direction = "asc"
    @sort_option = session[:venue_stats_sort_option] = params[:sort_option] || session[:venue_stats_sort_option] || default_sort_option
    @sort_direction = session[:venue_stats_sort_direction] = params[:sort_direction] || session[:venue_stats_sort_direction] || default_sort_direction
  end

  def handle_filter
    @runs = Run.where(date: @date)
    @runs = RunQuery.new(session, @runs, :venue_stats).call
  end

  def prepare_filter_options
    prepare_dates
    prepare_agegroups
  end

  def handle_sort
    @venue_stats = @venue_stats.order("#{@sort_option} #{@sort_direction}")
  end

  def summary_stats_method
    if session[:venue_stats_filter_any_agegroup_of]
      :full_query
    else
      :stored_stats
    end
  end

  def handle_summary_stats
    # Use of lambda for lazy execution (only run if needed)
    full_query_method = -> { @runs.unscope(:order).summary_stats(group_by: "parkrun") }
    @venue_stats = case summary_stats_method
    when :full_query
      full_query_method.call
    when :stored_stats
      StoredStats.for(@date) || full_query_method.call
    end
  end

  # def handle_pagination
  #   pagy_limit = 100
  #   @pagy, @venue_stats = pagy(:countish, @venue_stats, limit: pagy_limit)
  # end
end
