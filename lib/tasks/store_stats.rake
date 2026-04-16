desc "build the database of stored stats"
task store_stats: :environment do
  date = Date.parse("18 April 2026")
  Run.where(date:).select(:parkrun).distinct.each do |run|
    parkrun = run.parkrun
    puts "Computing stats for #{parkrun} on #{date}"
    StoredStats.compute_summary_for(date, parkrun)
  end
end

# desc "build the database of stored stats"
# task store_stats: :environment do
#   start_date = Date.new(2026, 1, 3)
#   end_date = Date.new(2026, 4, 11)
#   dates = (start_date..end_date).step(7).to_a
#   dates.each do |date|
#     Run.where(date:).select(:parkrun).distinct.each do |run|
#       parkrun = run.parkrun
#       puts "Computing stats for #{parkrun} on #{date}"
#       StoredStats.compute_summary_for(date, parkrun)
#     end
#   end
# end
