class ChartsController < ApplicationController
  allow_unauthenticated_access
  def count_by_time
    handle_filter
    @grouping_size = @runs.size < 2000 ? 60 : 20
    line_chart_data = @runs.group("FLOOR(time / #{@grouping_size}) * #{@grouping_size}").count(:time).sort.to_h.transform_keys do |seconds|
                    time = Time.at(seconds).utc
                    if seconds < 3600
                      time.strftime("%-M:%S")   # mm:ss
                    else
                      time.strftime("%-H:%M:%S") # h:mm:ss
                    end
                  end
    render json: line_chart_data
  end

  def count_by_agegroup
    handle_filter
    column_chart_data = @runs.group(:agegroup).order(:agegroup).count
    # @runs.unscope(:order).group(:agegroup).order("count_all DESC").count
    render json: column_chart_data
  end

  private

  def handle_filter
    date = session[:run_filter_date]
    parkrun = session[:run_filter_venue]
    @runs = Run.where(date:)
    @runs = @runs.where(parkrun:) unless parkrun == "All"
    @runs = RunQuery.new(session, @runs, :run).call
  end
end
