class RunsController < ApplicationController
  allow_unauthenticated_access
  before_action :initialize_sort, only: :index

  def index
    prepare_dates
    prepare_agegroups
    date = session[:filter_date] || @dates&.first
    @runs = Run.where(date:)
    handle_filter
    handle_sort
    @chart_runs = @runs.unscope(:order).group("FLOOR(time / 20.0) * 20").count(:time).sort.to_h.transform_keys do |seconds|
                    time = Time.at(seconds).utc
                    if seconds < 3600
                      time.strftime("%-M:%S")   # mm:ss
                    else
                      time.strftime("%-H:%M:%S") # h:mm:ss
                    end
                  end
    @summary_stats = @runs.unscope(:order).summary_stats(agegroups: session[:filter_any_agegroup], group_by_parkrun: false)
    @pagy, @runs = pagy(:countish, @runs, limit: 10000, size: 25)

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
    # clear_session(:date, :filter_any_agegroup_of)
    set_session(:date, :any_agegroup_of)
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
end
