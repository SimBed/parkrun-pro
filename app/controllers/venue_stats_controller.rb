class VenueStatsController < ApplicationController
  allow_unauthenticated_access
  before_action :initialize_sort, only: :index

  def index
    prepare_dates
    prepare_agegroups
    date = session[:venue_stats_filter_date] || @dates&.first
    @runs = Run.where(date:)
    handle_filter
    @venue_stats = @runs.summary_stats.select(:parkrun).group(:parkrun)
    handle_sort
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

  def handle_filter
    @runs = RunQuery.new(session, @runs, :venue_stats).call
  end

  def initialize_sort
    session[:venue_stats_sort_option] = params[:venue_stats_sort_option] || session[:venue_stats_sort_option] || "parkrun"
  end

  def handle_sort
    # @runs = @runs.send("order_by_#{session[:venue_stats_sort_option]}")
    sort_option = session[:venue_stats_sort_option]
    sort_order = "ASC"
    sort_order = "DESC" if %w[count slowest].include? sort_option
    @venue_stats = @venue_stats.order("#{session[:venue_stats_sort_option]} #{sort_order}")
  end
end
