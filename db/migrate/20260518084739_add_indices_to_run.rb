class AddIndicesToRun < ActiveRecord::Migration[8.1]
  def change
    add_index :runs, [:agegroup, :time]
    add_index :runs, [:agegroup, :name, :time]
  end
end