class Run < ApplicationRecord
  START_DATE = Date.new(2026, 1, 3)
  scope :order_by_time_asc, -> { order(time: :asc, name: :asc) }
  scope :order_by_time_desc, -> { order(time: :desc, name: :asc) }
  scope :order_by_agegrade_asc, -> { order("agegrade ASC NULLS LAST, time ASC, name ASC") }
  scope :order_by_agegrade_desc, -> { order("agegrade DESC NULLS LAST, time ASC, name ASC") }
  scope :order_by_runs_asc, -> { order(runs: :asc, time: :asc, name: :asc) }
  scope :order_by_runs_desc, -> { order(runs: :desc, name: :asc) }
  scope :order_by_parkrun, -> { order(:parkrun) }
  scope :has_agegroup_like, ->(key) { where("agegroup LIKE ?", "%#{key}%") }
  # the nulls in agegrade would get ordered first by default
  # scope :order_by_agegrade, -> { order(agegrade: :desc, time: :asc, name: :asc) }
  scope :any_agegroup_of, ->(agegroup_filter) { where(agegroup: agegroup_filter) }

  def anonymized_name
    # Rails.env == 'production' ? name.split.map {|a| a.first}.join : name
    # Rails.env == "production" ? name.split.map { |n| n.split("").shuffle.join }.join(" ") : name
    name
  end

  def self.parkruns
    # NOTE: Run.distinct(:parkrun) (without the pluck) doesnt return what is intuitively expected. Run.select(:parkrun).distinct works as expected.
    order(parkrun: :asc).distinct.pluck(:parkrun)
  end

  def self.agegroups
    order(agegroup: :asc).distinct.pluck(:agegroup)
  end

  def self.agegroup_like(key)
    has_agegroup_like(key).distinct.pluck(:agegroup)
  end

  def self.dates
    # order(date: :desc).distinct.pluck(:date)
    this_saturday = Date.current.beginning_of_week(:saturday)

    (START_DATE..this_saturday).step(7).to_a
  end

  def self.summary_stats
    select(<<~SQL)
      COUNT(time) AS count,
      MIN(time) AS fastest,
      MAX(time) AS slowest,
      percentile_cont(0.5) WITHIN GROUP (ORDER BY time) AS median,
      AVG(time) AS mean,
      STDDEV(time) AS stddev,
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
  end

  # Returns the number of duplicate records that would be deleted
  def self.duplicate_count
    sql = <<~SQL
      SELECT COUNT(*) FROM (
        SELECT id,
               ROW_NUMBER() OVER (
                 PARTITION BY name, date, time, parkrun, agegrade
                 ORDER BY id
               ) AS row_num
        FROM #{table_name}
      ) t
      WHERE row_num > 1;
    SQL

    connection.select_value(sql).to_i
  end

  def self.delete_duplicates!
    connection.execute(<<~SQL)
      DELETE FROM #{table_name}
      WHERE id IN (
        SELECT id FROM (
          SELECT id,
                 ROW_NUMBER() OVER (
                   PARTITION BY name, date, time, parkrun, agegrade
                   ORDER BY id
                 ) AS row_num
          FROM #{table_name}
        ) t
        WHERE row_num > 1
      );
    SQL
  end
end
