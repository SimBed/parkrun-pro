class RenameParkrunToVenueInStoredStats < ActiveRecord::Migration[8.1]
  def change
    rename_column :stored_stats, :parkrun, :venue
  end
end
