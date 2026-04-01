desc "test speed of stats calc"
task speedtest: :environment do
  start = Time.now
  Run.summary_stats.select(:parkrun).group(:parkrun)
  puts Time.now - start
end
