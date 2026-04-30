desc "test speed of stats calc"
task speedtest: :environment do
  start = Time.now
  # Run.summary_stats.select(:parkrun).group(:parkrun)
  # Run.group(:agegroup).order_by_agegroup.count
  # Run.distinct.pluck(:date)
  Run.distinct.order(parkrun: :asc).pluck(:parkrun)
  puts Time.now - start
end
