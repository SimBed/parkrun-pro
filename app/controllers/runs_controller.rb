class RunsController < ApplicationController
  allow_unauthenticated_access
  before_action :initialize_sort, only: :index

  def index
    prepare_dates
    prepare_agegroups
    date = session[:filter_date] || @dates&.first
    parkrun = session[:filter_parkrun] || "All"
    @runs = Run.where(date:)
    prepare_parkruns
    @runs = @runs.where(parkrun:) unless parkrun == "All"
    handle_filter
    handle_sort
    @grouping_size = @runs.size < 2000 ? 60 : 20
    @line_chart_count_by_time = @runs.unscope(:order).group("FLOOR(time / #{@grouping_size}) * #{@grouping_size}").count(:time).sort.to_h.transform_keys do |seconds|
                    time = Time.at(seconds).utc
                    if seconds < 3600
                      time.strftime("%-M:%S")   # mm:ss
                    else
                      time.strftime("%-H:%M:%S") # h:mm:ss
                    end
                  end
    @chart_title = "#{parkrun + (parkrun == 'All' ? ' Venues' : '') }, #{date}"
    @chart_sub_title = if session[:filter_any_agegroup_of]
      "(#{helpers.pluralize(session[:filter_any_agegroup_of].length, 'age-group')} selected)"
    else
      "(All age-groups)"
    end
    @column_chart_count_by_agegroup = @runs.unscope(:order).group(:agegroup).order(:agegroup).count
    # @column_chart_count_by_agegroup = @runs.unscope(:order).group(:agegroup).order("count_all DESC").count
    @summary_stats = @runs.unscope(:order).summary_stats
    pagy_limit = 1000
    if params[:time].present? && params[:time] =~ /\A\d{1,2}:\d{2}(:\d{2})?\z/
      seconds = parse_time_to_seconds(params[:time])

      position = @runs.where("time < ?", seconds).count
      page = (position / pagy_limit) + 1

      redirect_to runs_path(page: page) and return
    end
    @show_pagy = true if @runs.size > pagy_limit
    @pagy, @runs = pagy(:countish, @runs, limit: pagy_limit, size: 25)
  end

  def parkruns
    @parkruns = Run.parkruns
    @agegroups = Run.agegroups
  end

  def clear_filters
    clear_session(:filter_any_agegroup_of)
    redirect_to runs_path
  end

  def filter
    clear_session(:filter_date, :filter_parkrun, :filter_any_agegroup_of)
    set_session(:date, :parkrun, :any_agegroup_of)
    redirect_to runs_path
  end

  private

  def handle_filter
    @runs = RunQuery.new(session, @runs).call
  end

  def initialize_sort
    session[:run_sort_option] = params[:run_sort_option] || session[:run_sort_option] || "time"
  end

  def handle_sort
    @runs = @runs.send("order_by_#{session[:run_sort_option]}")
  end

  def prepare_agegroups
    @agegroup_columns = { junior: Run.agegroup_like("J"),
                men: Run.agegroup_like("SM") + Run.agegroup_like("VM"),
                women: Run.agegroup_like("SW") + Run.agegroup_like("VW"),
                wheelchair: Run.agegroup_like("WC")
              }
  end

  def prepare_dates
    @dates = Run.dates.map { |date| date.strftime("%d %B %Y") }
  end

  def prepare_parkruns
    @parkruns = [ [ "All Venues", "All" ] ] + @runs.distinct(:parkrun).order(:parkrun).pluck(:parkrun)
  end

  def parse_time_to_seconds(str)
    parts = str.split(":").map(&:to_i)

    case parts.length
    when 2
      m, s = parts
      m * 60 + s
    when 3
      h, m, s = parts
      h * 3600 + m * 60 + s
    else
      0
    end
  end
end
