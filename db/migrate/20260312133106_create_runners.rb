class CreateRunners < ActiveRecord::Migration[8.1]
  def change
    create_table :runners do |t|
      t.string :name
      t.string :gender
      t.string :agegroup
      t.integer :time

      t.timestamps
    end
    add_index :runners, :name
    add_index :runners, :gender
    add_index :runners, :agegroup
    add_index :runners, :time
  end
end
