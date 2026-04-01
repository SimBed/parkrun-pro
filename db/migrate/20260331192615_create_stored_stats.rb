class CreateStoredStats < ActiveRecord::Migration[8.1]
  def change
    create_table :stored_stats do |t|
      t.date :date, null: false, index: true
      t.string :parkrun, null: false, index: true

      t.integer :count
      t.integer :fastest
      t.integer :slowest
      t.float :median
      t.float :mean
      t.float :stddev
      t.float :avg_age

      t.timestamps
    end
    add_index :stored_stats, [ :date, :parkrun ], unique: true
  end
end
