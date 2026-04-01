class CreateSummaryStats < ActiveRecord::Migration[8.1]
  def change
    create_view :summary_stats, materialized: true
  end
end
