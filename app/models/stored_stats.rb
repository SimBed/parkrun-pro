class StoredStats < ApplicationRecord
  def self.for(date, venue = nil)
    return find_by(date:, venue:) if venue

    where(date:)
  end

  def self.compute_summary_for(date, venue)
    result = Run.where(date: date, venue: venue).summary_stats.take

    StoredStats.create!({
      date: date,
      venue: venue,
      count: result.count,
      fastest: result.fastest,
      slowest: result.slowest,
      median: result.median,
      # mean: result.mean,
      # stddev: result.stddev,
      avg_age: result.avg_age
    })
  end
end
