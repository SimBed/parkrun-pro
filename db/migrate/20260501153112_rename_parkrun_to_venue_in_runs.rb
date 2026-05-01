class RenameParkrunToVenueInRuns < ActiveRecord::Migration[8.1]
  def change
    rename_column :runs, :parkrun, :venue
  end
end
