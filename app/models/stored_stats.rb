class StoredStats < ApplicationRecord
  def self.for(date, parkrun = nil)
    return find_by(date:, parkrun:) if parkrun

    where(date:)
  end

  def self.compute_summary_for(date, parkrun)
    result = Run.where(date: date, parkrun: parkrun).summary_stats.take

    StoredStats.create!({
      date: date,
      parkrun: parkrun,
      count: result.count,
      fastest: result.fastest,
      slowest: result.slowest,
      median: result.median,
      mean: result.mean,
      stddev: result.stddev,
      avg_age: result.avg_age
    })
  end
end
