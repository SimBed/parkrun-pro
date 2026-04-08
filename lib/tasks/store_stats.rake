desc "build the database of stored stats"
task store_stats: :environment do
    # Run.select(:date).distinct.each do |run|
    #   date = run.date
    date = Date.parse("17 January 2026")
    Run.where(date:).select(:parkrun).distinct.each do |run|
      parkrun = run.parkrun
      puts "Computing stats for #{parkrun} on #{date}"
        StoredStats.compute_summary_for(date, parkrun)
    end
  # end
end
