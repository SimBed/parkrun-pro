class RunsController < ApplicationController
  allow_unauthenticated_access
  before_action :initialize_sort, only: :index

  def index
    prepare_dates
    prepare_agegroups
    @date = session[:run_filter_date] || @dates&.first
    @parkrun = session[:run_filter_venue] || "All"
    @runs = Run.where(date: @date)
    prepare_parkruns
    @runs = @runs.where(parkrun: @parkrun) unless @parkrun == "All"
    handle_filter
    handle_sort
    handle_headings
    # @column_chart_count_by_agegroup = @runs.unscope(:order).group(:agegroup).order(:agegroup).count
    # @column_chart_count_by_agegroup = @runs.unscope(:order).group(:agegroup).order("count_all DESC").count
    handle_summary_stats
    handle_pagination
  end

  def parkruns
    @parkruns = Run.parkruns
    @agegroups = Run.agegroups
  end

  def clear_filters
    clear_session(:run_filter_any_agegroup_of)
    redirect_to runs_path
  end

  def filter
    clear_session(:run_filter_date, :run_filter_venue, :run_filter_any_agegroup_of)
    set_session("run", :date, :venue, :any_agegroup_of)
    redirect_to runs_path
  end

  private

  def handle_filter
    @runs = RunQuery.new(session, @runs, :run).call
  end

  def initialize_sort
    session[:run_sort_option] = params[:run_sort_option] || session[:run_sort_option] || "time"
  end

  def handle_sort
    @runs = @runs.send("order_by_#{session[:run_sort_option]}")
  end

  def prepare_parkruns
    @parkruns = [ [ "All Venues", "All" ] ] + @runs.distinct(:parkrun).order(:parkrun).pluck(:parkrun)
  end

  def handle_headings
    # needed for chart title, which cant it seems be passed by the chart endppoint
    @grouping_size = @runs.size < 2000 ? 60 : 20

    @summary_title = "#{@parkrun + (@parkrun == 'All' ? ' Venues' : '') }, #{@date}"
    @summary_sub_title = if session[:run_filter_any_agegroup_of]
      "(#{helpers.pluralize(session[:run_filter_any_agegroup_of].length, 'age-group')} selected)"
    else
      "(All age-groups)"
    end
  end

  def summary_stats_method
    if session[:run_filter_any_agegroup_of]
      :full_query
    elsif @parkrun == "All"
      :material_view
    else
      :stored_stats
    end
  end

  def handle_summary_stats
    @summary_stats = case summary_stats_method
    when :full_query
      @runs.unscope(:order).summary_stats[0]
    when :material_view
      SummaryStats.on(@date)[0]
    when :stored_stats
      StoredStats.for(@date, @parkrun)
    end
  end

  def handle_pagination
    pagy_limit = 1000
    time_input = params[:time]
    if Utility::TimeParser.correct_time_format?(time_input)
      page = Utility::PageFinder.find_page(time_input, @runs, pagy_limit)
      redirect_to runs_path(page: page) and return
    end
    @show_pagy = true if @runs.size > pagy_limit
    @pagy, @runs = pagy(:countish, @runs, limit: pagy_limit, size: 25)
  end
end
