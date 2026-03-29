class ChangeParkrunToVenue < ActiveRecord::Migration[8.1]
  def change
    rename_table :parkruns, :venues
  end
end
