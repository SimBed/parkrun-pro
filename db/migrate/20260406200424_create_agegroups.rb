class CreateAgegroups < ActiveRecord::Migration[8.1]
  def change
    create_table :agegroups do |t|
      t.string :name
      t.integer :position
      t.string :category
      t.string :gender
      t.integer :average_age
      t.boolean :active

      t.timestamps
    end
    add_index :agegroups, :name, unique: true
    add_index :agegroups, :position
    add_index :agegroups, :category
    add_index :agegroups, :gender
  end
end
