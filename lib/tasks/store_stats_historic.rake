desc "build the database of stored stats for earlier dates fro previously omitted venues "
task store_stats_historic: :environment do
  start_date = Date.new(2026, 1, 3)
  end_date = Date.new(2026, 9, 5)
  dates = (start_date..end_date).step(7).to_a
  venue = "St Matthew's Field"
  dates.each do |date|
    puts "Computing stats for #{venue} on #{date}"
    StoredStats.compute_summary_for(date, venue)
  end
end
