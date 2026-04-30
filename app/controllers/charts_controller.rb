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
    column_chart_data = @runs.group(:agegroup).order_by_agegroup.count
    render json: column_chart_data
  end

  def count_by_date
    line_chart_data = Run.group(:date).count(:date)
    render json: line_chart_data
  end

  def fastest_time_by_date
    line_chart_data = Run.group(:date).minimum(:time)
    render json: line_chart_data
  end

  def median_time_by_date
    line_chart_data = Run
      .group(:date)
      .pluck(
        :date,
        Arel.sql("percentile_cont(0.5) WITHIN GROUP (ORDER BY time) AS median")
        )
      .to_h
    render json: line_chart_data
  end

  def slowest_time_by_date
    line_chart_data = Run.group(:date).maximum(:time)
    render json: line_chart_data
  end

  def avg_age_by_date
    line_chart_data = Run
      .group(:date)
      .pluck(
        :date,
        Arel.sql(<<~SQL
                      AVG(
                        CASE
                          WHEN agegroup ~ '\\d+-\\d+' THEN
                            (
                              substring(agegroup FROM '\\d+')::int +
                              substring(agegroup FROM '-(\\d+)')::int
                            ) / 2.0
                          WHEN agegroup ~ '\\d+' THEN
                            substring(agegroup FROM '\\d+')::int
                          ELSE NULL
                        END
                      ) AS avg_age
                    SQL
                )
        )
      .to_h.transform_values do |age|
                              helpers.number_with_precision(age, precision: 1)
                           end
    render json: line_chart_data
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
