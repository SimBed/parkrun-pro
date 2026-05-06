# desc "build the database of stored stats"
# task store_stats: :environment do
#   date = Date.parse("2 May 2026")
#   Run.where(date:).select(:venue).distinct.each do |run|
#     venue = run.venue
#     puts "Computing stats for #{venue} on #{date}"
#     StoredStats.compute_summary_for(date, venue)
#   end
# end

desc "build the database of stored stats"
task store_stats: :environment do
  StoredStats.delete_all
  start_date = Date.new(2026, 1, 3)
  end_date = Date.new(2026, 5, 2)
  dates = (start_date..end_date).step(7).to_a
  dates.each do |date|
    Run.where(date:).select(:venue).distinct.each do |run|
      venue = run.venue
      puts "Computing stats for #{venue} on #{date}"
      StoredStats.compute_summary_for(date, venue)
    end
  end
end
