class AddAgegradeToRunners < ActiveRecord::Migration[8.1]
  def change
    add_column :runners, :position, :integer
    add_column :runners, :runs, :integer
    add_column :runners, :agegrade, :decimal, precision: 5, scale: 2
    add_column :runners, :parkrun_name, :string

    add_index :runners, :position
    add_index :runners, :runs
    add_index :runners, :agegrade
    add_index :runners, :parkrun_name
  end
end
