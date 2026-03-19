class Run < ApplicationRecord
  scope :order_by_time, -> { order(time: :asc, name: :asc) }
  scope :order_by_agegrade, -> { order("agegrade DESC NULLS LAST, time ASC, name ASC") }
  scope :order_by_runs, -> { order(runs: :desc, name: :asc) }
  scope :has_agegroup_like, ->(key) { where("agegroup LIKE ?", "%#{key}%") }
  # the nulls in agegrade would get ordered first by default
  # scope :order_by_agegrade, -> { order(agegrade: :desc, time: :asc, name: :asc) }
  scope :any_agegroup_of, ->(agegroup_filter) { where(agegroup: agegroup_filter) }

  def self.parkruns
    order(parkrun: :asc).distinct.pluck(:parkrun)
  end

  def self.agegroups
    order(agegroup: :asc).distinct.pluck(:agegroup)
  end

  def self.agegroup_like(key)
    has_agegroup_like(key).distinct.pluck(:agegroup)
  end

  def self.dates
    order(date: :desc).distinct.pluck(:date)
  end

  def self.summary_stats(agegroups: nil, group_by_parkrun: true)
    query = all

    query = query.where(agegroup: agegroups) if agegroups.present?

    if group_by_parkrun
    query
    .group(:parkrun)
    .select(<<~SQL)
      parkrun,
      COUNT(time) AS count,
      AVG(time) AS mean,
      STDDEV(time) AS stddev,
      MIN(time) AS min,
      MAX(time) AS max,
      percentile_cont(0.5) WITHIN GROUP (ORDER BY time) AS median
    SQL
    .order(:parkrun).index_by(&:parkrun)
    else
      query
      .select(<<~SQL)
        COUNT(time) AS count,
        MIN(time) AS min,
        MAX(time) AS max,
        percentile_cont(0.5) WITHIN GROUP (ORDER BY time) AS median,
        AVG(time) AS mean,
        STDDEV(time) AS stddev
      SQL
    end
  end
end
