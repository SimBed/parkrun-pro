class CreateMps < ActiveRecord::Migration[8.1]
  def change
    create_table :mps do |t|
      t.string :name
      t.string :party
      t.string :constituency
      t.string :agegroup
      t.integer :pb
      t.date :date
      t.string :venue
      t.integer :runs

      t.timestamps
    end
  end
end
