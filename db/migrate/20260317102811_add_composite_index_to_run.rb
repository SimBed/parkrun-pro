class AddCompositeIndexToRun < ActiveRecord::Migration[8.1]
  def change
    add_index :runs, [ :parkrun_name, :time, :date ]
  end
end
