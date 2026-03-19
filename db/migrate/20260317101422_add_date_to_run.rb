class AddDateToRun < ActiveRecord::Migration[8.1]
  def change
    add_column :runs, :date, :date
    add_index :runs, :date
  end
end
