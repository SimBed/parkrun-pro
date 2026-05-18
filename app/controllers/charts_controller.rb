class ChartsController < ApplicationController
  allow_unauthenticated_access
  def count_by_time
    extract_filters
    handle_filters
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
    extract_filters
    handle_filters
    column_chart_data = @runs.group(:agegroup).order_by_agegroup.count
    render json: column_chart_data
  end

  # def count_by_date
  #   line_chart_data = Run.group(:date).count(:date)
  #   render json: line_chart_data
  # end
  def count_by_date
    male_agegroups = Agegroup.where(gender: "male").pluck(:name)
    female_agegroups = Agegroup.where(gender: "female").pluck(:name)
    male_data = Run.where(agegroup: male_agegroups).group(:date).order(:date).count.transform_keys { |date| date.strftime("%b %-d") }
    female_data = Run.where(agegroup: female_agegroups).group(:date).order(:date).count.transform_keys { |date| date.strftime("%b %-d") }
    non_specified_data = Run.where(agegroup: "").group(:date).order(:date).count.transform_keys { |date| date.strftime("%b %-d") }
    line_chart_data = [ { name: "Male", data: male_data }, { name: "Female", data: female_data }, { name: "Not Specified", data: non_specified_data } ]
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

  def over80s_by_date
    male_over_80_agegroups = [ "VM80-84", "VM85-89", "VM90-94", "VM95-99" ]
    female_over_80_agegroups = [ "VW80-84", "VW85-89", "VW90-94", "VW95-99" ]
    # over_80_agegroups = male_over_80_agegroups + female_over_80_agegroups
    # have to transform date otherwise formatting gets changed to 2026-mm-dd. Then need to order by date to avoid random ordering.
    male_data =Run.where(agegroup: male_over_80_agegroups).group(:date).order(:date).count.transform_keys { |date| date.strftime("%b %-d") }
    female_data =Run.where(agegroup: female_over_80_agegroups).group(:date).order(:date).count.transform_keys { |date| date.strftime("%b %-d") }
    # With Chartkick you can pass an array of series hashes for multiple lines on the same chart
    line_chart_data = [ { name: "Male", data: male_data }, { name: "Female", data: female_data } ]
    # line_chart_data = Run.where("agegroup IN (?)", over_80_agegroups).group(:date).count
    render json: line_chart_data
  end

  def over90s_by_date
    male_over_90_agegroups = [ "VM90-94", "VM95-99" ]
    female_over_90_agegroups = [ "VW90-94", "VW95-99" ]
    male_data =Run.where(agegroup: male_over_90_agegroups).group(:date).order(:date).count.transform_keys { |date| date.strftime("%b %-d") }
    female_data =Run.where(agegroup: female_over_90_agegroups).group(:date).order(:date).count.transform_keys { |date| date.strftime("%b %-d") }
    line_chart_data = [ { name: "Male", data: male_data }, { name: "Female", data: female_data } ]
    render json: line_chart_data
  end

  private

  def extract_filters
    @date = params[:date]
    @venue = params[:venue]
    @filters = (params[:filters] || {})
  end

  def handle_filters
    @runs = Run.where(date: @date)
    @runs = @runs.where(venue: @venue) unless @venue == "All"
    @runs = RunQuery.new(@filters, @runs, :runs).call
  end
end
