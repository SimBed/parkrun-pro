desc "refresh the material view"
task summary_stats: :environment do
  SummaryStats.refresh
end
